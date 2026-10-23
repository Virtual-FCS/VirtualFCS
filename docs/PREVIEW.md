# Documentation Preview

`generate_preview.py` is a Windows-compatible alternative to the legacy
`GenerateDoc.mos`. It does not modify that script, existing HTML, or Modelica
sources. Each run creates a new `docs-preview-<UTC timestamp>` directory beside
`docs`. An explicit `--output` directory must not already exist.
Each generated folder includes both `generate_preview.py` and this `PREVIEW.md`
so the generation instructions remain available after replacing the old folder.

## Run

Use a Python environment with OpenModelica available to OMPython:

```powershell
python -m pip install OMPython beautifulsoup4
python .\docs\generate_preview.py
```

Run these commands from the repository directory containing `docs` and the
`VirtualFCS` Modelica package directory. For a quick sample:

```powershell
python .\docs\generate_preview.py --limit 5
```

The local package is loaded explicitly; its `uses` annotation requests Modelica
4.1.0 and Modelica_DeviceDrivers 2.1.0. Install those libraries in OpenModelica
before running. No simulation or model-icon rendering is performed. 