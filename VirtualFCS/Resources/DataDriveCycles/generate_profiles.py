#!/usr/bin/env python
#-*- coding: utf-8 -*-
#
# Copyright 2025 SINTEF Digital
# Generation of MAT files with NEDC and WLTC driving cycles (all classes).
# Companion files taken from the wltp Python package (in turn produced by JRC).
# Definition of WLTC is available from UN Website:
# https://wiki.unece.org/display/trans/Latest+GTR+15


import numpy as np
from scipy.io import savemat

import class1, class2, class3, nedc

v_WLTC_1 = class1.class_data()['cycle']
v_WLTC_1 = v_WLTC_1 + v_WLTC_1[:class1.class_data()['parts'][1][0]]
savemat("WLTC1.mat", {'WLTC1': np.array(list(enumerate(v_WLTC_1)))})

v_WLTC_2 = class2.class_data()['cycle']
savemat("WLTC2.mat", {'WLTC2': np.array(list(enumerate(v_WLTC_2)))})

v_WLTC_3a = class3.class_data_a()['cycle']
v_WLTC_3b = class3.class_data_b()['cycle']
savemat("WLTC3a.mat", {'WLTC3a': np.array(list(enumerate(v_WLTC_3a)))})
savemat("WLTC3b.mat", {'WLTC3b': np.array(list(enumerate(v_WLTC_3b)))})

v_NEDC=nedc.cycle_data()['cycle']
savemat("NEDC.mat", {'NEDC': np.array(list(enumerate(v_NEDC)))})

