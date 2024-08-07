#!/usr/bin/env python3

import mms
import sympy

u = 'sin(pi*x)*sin(2*pi*y)+1.5'
v = '0.5*e_k'

f_u, e_u = mms.evaluate('div(v*u)', u, variable='u', v=v, transformation='cylindrical', coordinate_names=('x', 'phi', 'y'))

mms.print_hit(e_u, 'analytic_solution')
mms.print_hit(f_u, 'source_func')
