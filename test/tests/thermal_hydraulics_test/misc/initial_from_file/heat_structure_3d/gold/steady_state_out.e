CDF      
      
len_string     !   len_line   Q   four      	time_step          len_name   !   num_dim       	num_nodes         num_elem      
num_el_blk        num_node_sets         num_side_sets         num_el_in_blk1        num_nod_per_el1       num_side_ss1      num_side_ss2      num_side_ss3      num_side_ss4      num_side_ss5      num_side_ss6      num_nod_ns1    	   num_nod_ns2    	   num_nod_ns3    	   num_nod_ns4    	   num_nod_ns5    	   num_nod_ns6    	   num_nod_var       num_info   �         api_version       @�
=   version       @�
=   floating_point_word_size            	file_size               int64_status             title         steady_state_out.e     maximum_name_length                 &   
time_whole                            [�   	eb_status                             
@   eb_prop1               name      ID              
D   	ns_status         	                    
H   ns_prop1      	         name      ID              
`   	ss_status         
                    
x   ss_prop1      
         name      ID              
�   coordx                      �      
�   coordy                      �      �   coordz                      �      X   eb_names                       $      0   ns_names      	                 �      T   ss_names      
                 �         
coor_names                         d      �   node_num_map                    l      H   connect1                  	elem_type         HEX8                �   elem_num_map                           �   elem_ss1                          �   side_ss1                          �   elem_ss2                          �   side_ss2                             elem_ss3                             side_ss3                          $   elem_ss4                          4   side_ss4                          D   elem_ss5                          T   side_ss5                          d   elem_ss6                          t   side_ss6                          �   node_ns1                    $      �   node_ns2                    $      �   node_ns3                    $      �   node_ns4                    $          node_ns5                    $      $   node_ns6                    $      H   vals_nod_var1                          �      [�   name_nod_var                       $      l   info_records                      I      �                                                                                 ��     ��      ��      ��     �����s	                �����s	����������������<����s	<����s	��      ��             �����s	��������<����s	?�������?�      ?�      ?�������?�     ?�     ?�      ?�������?�     ��      ��                      ��      ��                      ��              ��              ?�      ?�      ?�      ?�      ?�      ?�      ��      ��                      ��              ?�      ?�      ?�      @      ���&3\���&3\@      @                      @      �      �      �      �      ���&3\@              @      �      �      @      <��&3\<��&3\@      �      �      <��&3\@      �      blk:brick                                                                                                                                                                                                                                   blk:left                         blk:top                          blk:back                         blk:bottom                       blk:right                        blk:front                                                                                                                                                         	   
                                                                                 	   
                                             
                                                                                                                                                                                                                                                                                                                                    	                                                                     	   
                                    	   
         T_solid                             ####################@�     @�     @p     @p     @�     @�     @p     @�  # Created by MOOSE #�     @�     @�     @�     @�     @�     @�           ####################                                                             ### Command Line Arguments ###                                                    /Users/charlc/projects/moose/modules/thermal_hydraulics/thermal_hydraulics-o... pt -i steady_state.i --error --error-unused --error-override --no-gdb-backtra... ce### Version Info ###                                                           Framework Information:                                                           MOOSE Version:           git commit cc8d96838f on 2022-03-14                     LibMesh Version:                                                                 PETSc Version:           3.15.1                                                  SLEPc Version:           3.15.1                                                  Current Time:            Tue Mar 15 15:49:16 2022                                Executable Timestamp:    Tue Mar 15 15:23:47 2022                                                                                                                                                                                                  ### Input File ###                                                                                                                                                []                                                                                 inactive                       = (no_default)                                    initial_from_file_timestep     = LATEST                                          initial_from_file_var          = INVALID                                         allow_negative_qweights        = 1                                               custom_blocks                  = (no_default)                                    custom_orders                  = (no_default)                                    element_order                  = AUTO                                            order                          = AUTO                                            side_order                     = AUTO                                            type                           = GAUSS                                         []                                                                                                                                                                [Components]                                                                       inactive                       = (no_default)                                                                                                                     [./blk]                                                                            inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = HeatStructureFromFile3D                           control_tags                 = Components                                        enable                       = 1                                                 file                         = /Users/charlc/projects/moose/modules/therm... al_hydraulics/test/tests/misc/initial_from_file/heat_structure_3d/box.e              initial_T                    = Ts_init                                           position                     = '(x,y,z)=(       0,        0,        0)'          rotation                     = 0                                               [../]                                                                                                                                                             [./right_bnd]                                                                      inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = HSBoundarySpecifiedTemperature                    T                            = Ts_init                                           boundary                     = blk:right                                         control_tags                 = Components                                        enable                       = 1                                                 hs                           = blk                                             [../]                                                                          []                                                                                                                                                                [Executioner]                                                                      auto_preconditioning           = 1                                               inactive                       = (no_default)                                    isObjectAction                 = 1                                               type                           = Transient                                       abort_on_solve_fail            = 1                                               accept_on_max_fixed_point_iteration = 0                                          accept_on_max_picard_iteration = 0                                               auto_advance                   = INVALID                                         automatic_scaling              = INVALID                                         check_aux                      = 0                                               compute_initial_residual_before_preset_bcs = 0                                   compute_scaling_once           = 1                                               contact_line_search_allowed_lambda_cuts = 2                                      contact_line_search_ltol       = INVALID                                         control_tags                   = (no_default)                                    custom_abs_tol                 = 1e-50                                           custom_pp                      = INVALID                                         custom_rel_tol                 = 1e-08                                           direct_pp_value                = 0                                               disable_fixed_point_residual_norm_check = 0                                      disable_picard_residual_norm_check = 0                                           dt                             = 1                                               dtmax                          = 1e+30                                           dtmin                          = 1e-13                                           enable                         = 1                                               end_time                       = 1e+30                                           error_on_dtmin                 = 1                                               fixed_point_abs_tol            = 1e-50                                           fixed_point_algorithm          = picard                                          fixed_point_force_norms        = 0                                               fixed_point_max_its            = 1                                               fixed_point_min_its            = 1                                               fixed_point_rel_tol            = 1e-08                                           l_abs_tol                      = 1e-50                                           l_max_its                      = 100                                             l_tol                          = 0.001                                           line_search                    = basic                                           line_search_package            = petsc                                           max_xfem_update                = 4294967295                                      mffd_type                      = wp                                              n_max_nonlinear_pingpong       = 100                                             n_startup_steps                = 0                                               nl_abs_div_tol                 = 1e+50                                           nl_abs_step_tol                = 0                                               nl_abs_tol                     = 1e-08                                           nl_div_tol                     = 1e+10                                           nl_forced_its                  = 0                                               nl_max_funcs                   = 10000                                           nl_max_its                     = 10                                              nl_rel_step_tol                = 0                                               nl_rel_tol                     = 1e-07                                           normalize_solution_diff_norm_by_dt = 1                                           num_grids                      = 1                                               num_steps                      = 100                                             off_diagonals_in_auto_scaling  = 0                                               outputs                        = INVALID                                         petsc_options                  = INVALID                                         petsc_options_iname            = INVALID                                         petsc_options_value            = INVALID                                         picard_abs_tol                 = 1e-50                                           picard_custom_pp               = INVALID                                         picard_force_norms             = 0                                               picard_max_its                 = 1                                               picard_rel_tol                 = 1e-08                                           relaxation_factor              = 1                                               relaxed_variables              = (no_default)                                    reset_dt                       = 0                                               resid_vs_jac_scaling_param     = 0                                               restart_file_base              = (no_default)                                    scaling_group_variables        = INVALID                                         scheme                         = implicit-euler                                  skip_exception_check           = 0                                               snesmf_reuse_base              = 1                                               solve_type                     = NEWTON                                          splitting                      = INVALID                                         ss_check_tol                   = 1e-08                                           ss_tmin                        = 0                                               start_time                     = 0                                               steady_state_detection         = 0                                               steady_state_start_time        = 0                                               steady_state_tolerance         = 1e-08                                           time_period_ends               = INVALID                                         time_period_starts             = INVALID                                         time_periods                   = INVALID                                         timestep_tolerance             = 1e-13                                           trans_ss_check                 = 0                                               transformed_postprocessors     = (no_default)                                    transformed_variables          = (no_default)                                    update_xfem_at_timestep_begin  = 0                                               use_multiapp_dt                = 0                                               verbose                        = 0                                             []                                                                                                                                                                [Functions]                                                                                                                                                         [./Ts_init]                                                                        inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ParsedFunction                                    control_tags                 = Functions                                         enable                       = 1                                                 execute_on                   = LINEAR                                            vals                         = INVALID                                           value                        = '2*sin(x*pi/2)+2*sin(pi*y) +507'                  vars                         = INVALID                                         [../]                                                                          []                                                                                                                                                                [Materials]                                                                                                                                                         [./mat]                                                                            inactive                     = (no_default)                                      isObjectAction               = 1                                                 type                         = ADGenericConstantMaterial                         block                        = INVALID                                           boundary                     = INVALID                                           compute                      = 1                                                 constant_on                  = SUBDOMAIN                                         control_tags                 = Materials                                         declare_suffix               = (no_default)                                      enable                       = 1                                                 implicit                     = 1                                                 output_properties            = INVALID                                           outputs                      = none                                              prop_getter_suffix           = (no_default)                                      prop_names                   = 'density specific_heat thermal_conductivity'      prop_values                  = '16 356 6551.4'                                   seed                         = 0                                                 use_displaced_mesh           = 0                                               [../]                                                                          []                                                                                                                                                                [Outputs]                                                                          inactive                       = (no_default)                                    velocity_as_vector             = 1                                               append_date                    = 0                                               append_date_format             = INVALID                                         checkpoint                     = 0                                               color                          = 1                                               console                        = 1                                               controls                       = 0                                               csv                            = 0                                               dofmap                         = 0                                               execute_on                     = 'INITIAL FINAL'                                 exodus                         = 1                                               file_base                      = INVALID                                         gmv                            = 0                                               gnuplot                        = 0                                               hide                           = INVALID                                         interval                       = 1                                               json                           = 0                                               nemesis                        = 0                                               output_if_base_contains        = INVALID                                         perf_graph                     = 0                                               perf_graph_live                = 1                                               perf_graph_live_mem_limit      = 100                                             perf_graph_live_time_limit     = 5                                               print_linear_converged_reason  = 1                                               print_linear_residuals         = 1                                               print_mesh_changed_info        = 0                                               print_nonlinear_converged_reason = 1                                             print_perf_log                 = 0                                               show                           = INVALID                                         solution_history               = 0                                               sync_times                     = (no_default)                                    tecplot                        = 0                                               vtk                            = 0                                               xda                            = 0                                               xdr                            = 0                                               xml                            = 0                                             []                                                                                        @�     @�     @�     @�     @�     @�     @�     @�     @�     @�     @�     @�     @p     @p     @�     @�     @p     @�     @�     @�     @�     @�     @�     @�     @�     @�     @�     @Y      @���4c@���4b@�����I@�����I@�    @�    @�    @�    @���4b@�����H@�    @�    @p     @p     @�     @�     @p     @�     @�K��@�K��@�bXMO�@�bXMO�@�K��@�bXMO�@�     @�     @�     