import argparse
from contextlib import suppress
from datetime import datetime, timezone
import html
import json
from pathlib import Path
import shutil
import time
from urllib.parse import unquote, urlsplit

from bs4 import BeautifulSoup
from OMPython import OMCSessionZMQ


def expression(session, command):
    return session.sendExpression(command, parsed=command != "getErrorString()", raise_on_error=False)


def rewrite_markup(markup, session, output, classes, warnings):
    soup = BeautifulSoup(markup, "html.parser")
    for wrapper in soup.find_all(["html", "head", "body"]):
        wrapper.unwrap()
    for tag in soup.find_all(True):
        for attribute in ("href", "src"):
            value = tag.get(attribute)
            if not isinstance(value, str):
                continue
            if len(value) >= 2 and value[0] == value[-1] and value[0] in (chr(34), chr(39)):
                value = value[1:-1]
                tag[attribute] = value
            if not value.startswith("modelica://"):
                continue
            parsed = urlsplit(value)
            target = parsed.netloc + parsed.path
            class_name = target.replace("/", ".")
            if class_name in classes:
                replacement = class_name + ".html"
            elif not parsed.path or "/Resources/" not in target and attribute == "href":
                replacement = "https://build.openmodelica.org/Documentation/" + class_name + ".html"
            else:
                resolved = expression(session, "uriToFilename(" + json.dumps(value) + ")")
                source = Path(resolved) if isinstance(resolved, str) and resolved else None
                relative = Path(unquote(target))
                if relative.is_absolute() or ".." in relative.parts:
                    relative = Path("Resources") / parsed.netloc / Path(parsed.path).name
                destination = output / relative
                if source is None or not source.is_file():
                    warnings.append("Missing resource: " + value)
                    continue
                destination.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, destination)
                replacement = relative.as_posix()
            if parsed.fragment:
                replacement += "#" + parsed.fragment
            tag[attribute] = replacement
    return str(soup)


def validate(output):
    missing = set()
    for page in output.glob("*.html"):
        soup = BeautifulSoup(page.read_text(encoding="utf-8"), "html.parser")
        for tag in soup.find_all(True):
            for attribute in ("href", "src"):
                value = tag.get(attribute)
                if not isinstance(value, str) or not value:
                    continue
                parsed = urlsplit(value)
                if parsed.scheme or parsed.netloc or not parsed.path:
                    continue
                if not (page.parent / unquote(parsed.path)).is_file():
                    missing.add(page.name + ": " + value)
    return sorted(missing)


def main():
    started = time.monotonic()
    parser = argparse.ArgumentParser(description="Generate an isolated VirtualFCS documentation preview.")
    parser.add_argument("--output", type=Path, help="New output directory; existing directories are refused.")
    parser.add_argument("--limit", type=int, help="Generate a small sample for a smoke test.")
    parser.add_argument("--timeout", type=float, default=30, help="Compiler request timeout in seconds (default: 30).")
    args = parser.parse_args()
    docs = Path(__file__).resolve().parent
    package = docs.parent / "VirtualFCS/package.mo"
    generated_at = datetime.now(timezone.utc)
    stamp = generated_at.strftime("%Y%m%dT%H%M%S%fZ")
    timestamp = generated_at.strftime("%Y-%m-%d %H:%M:%S UTC")
    output = args.output.resolve() if args.output else docs.parent / ("docs-preview-" + stamp)
    if output.exists():
        raise FileExistsError("Refusing to overwrite existing output: " + str(output))
    output.mkdir(parents=True)
    session = OMCSessionZMQ(timeout=args.timeout)
    warnings = []
    try:
        expression(session, 'setCommandLineOptions("-d=nogen,noevalfunc")')
        if not expression(session, "loadFile(" + json.dumps(package.as_posix()) + ")"):
            raise RuntimeError(expression(session, "getErrorString()"))
        load_messages = expression(session, "getErrorString()")
        classes = sorted(set(expression(session, "getClassNames(VirtualFCS, recursive=true, qualified=true, sort=true)")) | {"VirtualFCS"})
        selected = classes if args.limit is None else classes[:args.limit]
        version = expression(session, "getVersion()")
        footer = ('<footer><hr>Generated at ' + timestamp
              + ' by <a href="https://openmodelica.org/">' + html.escape(version)
              + '</a> using <a href="generate_preview.py">generate_preview.py</a>.</footer>')
        compiler_messages = expression(session, "getErrorString()")
        known = set(selected)
        for position, name in enumerate(selected, 1):
            print(f"HTML [{position}/{len(selected)}] {name}", flush=True)
            annotation = expression(session, "getDocumentationAnnotation(" + name + ")")
            comment = expression(session, "getClassComment(" + name + ")")
            children = expression(session, "getClassNames(" + name + ", qualified=true, sort=false)")
            parts = ['<!doctype html><html lang="en"><head><meta charset="utf-8">',
                     '<meta name="viewport" content="width=device-width, initial-scale=1">',
                     '<link rel="stylesheet" href="style.css"><title>' + html.escape(name) + '</title></head><body>']
            segments = name.split(".")
            path = []
            for depth, segment in enumerate(segments, 1):
                ancestor = ".".join(segments[:depth])
                if ancestor in known and ancestor != name:
                    path.append('<a href="' + ancestor + '.html">' + html.escape(segment) + '</a>')
                else:
                    path.append(html.escape(segment))
            parts.extend(['<h1 id="' + name + '">' + ".".join(path) + "</h1>",
                          "<p>" + html.escape(comment or "") + "</p>"])
            for title, content in zip(("", "<h2>Revisions</h2>"), annotation[:2]):
                if content:
                    parts.append(title + rewrite_markup(content, session, output, known, warnings))
            if children:
                parts.append("<h2>Contents</h2><ul>")
                for child in children:
                    if child in known:
                        parts.append('<li><a href="' + child + '.html">' + html.escape(child.rsplit(".", 1)[-1]) + '</a></li>')
                parts.append("</ul>")
            parts.extend([footer, "</body></html>"])
            (output / (name + ".html")).write_text("\n".join(parts), encoding="utf-8")
        shutil.copy2(output / "VirtualFCS.html", output / "index.html")
        shutil.copy2(Path(__file__), output / "generate_preview.py")
        shutil.copy2(docs / "PREVIEW.md", output / "PREVIEW.md")
        (output / "style.css").write_text("body{max-width:1100px;margin:24px auto;padding:0 20px;font:16px/1.55 sans-serif;color:#222;background:#fff}h1{font-size:24px;overflow-wrap:anywhere}h2{font-size:20px}a{color:#006b73}pre{overflow:auto}table{border-collapse:collapse;max-width:100%;display:block;overflow:auto}td,th{padding:6px;border:1px solid #ccc}img{max-width:100%;height:auto}", encoding="utf-8")
        missing = validate(output)
        report = {"output": str(output), "openmodelica": version, "class_count": len(selected),
                  "available_class_count": len(classes), "load_messages": load_messages,
                  "generated_at": generated_at.isoformat(),
                  "compiler_messages": compiler_messages,
                  "elapsed_seconds": round(time.monotonic() - started, 2),
                  "icons_generated": False,
                  "warnings": warnings, "missing_local_targets": missing,
                  "external_links_checked": False}
        (output / "generation-report.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
        print(f"Preview: {output / 'index.html'}\nClasses: {len(selected)}; warnings: {len(warnings)}; missing local targets: {len(missing)}", flush=True)
        if missing:
            raise RuntimeError("Local link validation failed; see generation-report.json")
    finally:
        with suppress(Exception):
            expression(session, "quit()")


if __name__ == "__main__":
    main()