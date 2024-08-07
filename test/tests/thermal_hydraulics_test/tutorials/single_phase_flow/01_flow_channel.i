T_in = 300. # K
m_dot_in = 1e-2 # kg/s 质量流量越快，压力差越大
press = 10e5 # Pa

[GlobalParams]
  initial_p = ${press}
  initial_vel = 0.0001
  initial_T = ${T_in}
  gravity_vector = '0 0 0'#忽略重力影响

  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
  fp = he
[]

[FluidProperties]
  [he]
    type = IdealGasFluidProperties
    molar_mass = 4e-3 #摩尔质量g/mol
    gamma = 1.67 # 比热比
    k = 0.2556 #热导率W/m·K
    mu = 3.22639e-5 # 动力粘度Pa·S
  []
[]

[Closures]
  [thm_closures]#类似Kernel,不过是多个Kernel,大概是action？
    type = Closures1PhaseTHM
  []
[]

[Components]
  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'core_chan:in'
    m_dot = ${m_dot_in}
    T = ${T_in}
  []

  [core_chan]
    type = FlowChannel1Phase
    position = '0 0 0'
    orientation = '0 0 1'
    length = 1
    n_elems = 25 # 划分多少个网格
    A = 7.2548e-3 # 入口面积
    D_h = 7.0636e-2
  []

  [outlet]
    type = Outlet1Phase
    input = 'core_chan:out'
    p = ${press}
  []
[]

[Postprocessors]
  [core_p_in]#入口压力
    type = SideAverageValue
    boundary = core_chan:in
    variable = p
  []

  [core_p_out]#出口压力
    type = SideAverageValue
    boundary = core_chan:out
    variable = p
  []

  [core_delta_p]
    type = ParsedPostprocessor
    pp_names = 'core_p_in core_p_out'
    expression = 'core_p_in - core_p_out'
  []
[]

[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  line_search = basic

  start_time = 0
  end_time = 1000
  dt = 10

  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  nl_max_its = 25

[]

[Outputs]
  exodus = true

  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
[]
