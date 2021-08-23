#!/bin/bash
grep -v DOCTYPE tidy.err | grep -v "<body>" |grep -v "<html>\|</html>" |grep -v lacks |grep -v apos | grep -B1 Warning > tidy.filtered
