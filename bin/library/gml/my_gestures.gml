<?xml version="1.0" encoding="UTF-8"?>
<GestureMarkupLanguage xmlns:gml="http://gestureworks.com/gml/version/1.0">		
	
	<Gesture_set gesture_set_name="basic-core-gestures">
				
					<comment>The 'basic-core-gestures' are the simple form of the classic roate scale and drag gestures commonly used to manipulate touch objects.</comment>
		
					<Gesture id="n-drag" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points between 1 and 10. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
			
					<Gesture id="n-rotate" type="rotate">
					<comment>The 'n-rotate' gesture can be activated by any number of touch points between 2 and 10. When two or more touch points are recognized on a touch object the relative orientation
						of the touch points are tracked and grouped into a cluster. This change in the orientation of the cluster is mapped directly to the rotation of the touch object.</comment>
					
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="rotate"/>
								<returns>
									<property id="rotate_dtheta" result="dtheta"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="rotate">
									<property ref="rotate_dtheta" target="rotate"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					<Gesture id="n-scale" type="scale">
					
						<comment>The 'n-scale' gesture can be activated by any number of touch points between 2 and 10. When two or more touch points are recognized on a touch object the relative separation
						of the touch points are tracked and grouped into a cluster. Changes in the separation of the cluster are mapped directly to the scale of the touch object.</comment>
						
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<processing>
							<delta_filter>
								<property ref="scale_dsx" active="true" delta_min="0" delta_max=".2"/>
								<property ref="scale_dsy" active="true" delta_min="0" delta_max=".2"/>
							</delta_filter>
							<boundary_filter>
								<property ref="scale_dsx" active="true" boundary_min="0.6" boundary_max="1.2"/>
								<property ref="scale_dsy" active="true" boundary_min="0.6" boundary_max="1.2"/>
							</boundary_filter>
						</processing>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="scale"/>
								<returns>
									<property id="scale_dsx" result="ds"/>
									<property id="scale_dsy" result="ds"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="scale">
									<property ref="scale_dsx" target="scaleX"/>
									<property ref="scale_dsy" target="scaleY"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>

		</Gesture_set>	
		
	<Gesture_set gesture_set_name="tap-gesture">
					
				<Gesture id="n-tap" type="tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="200" translation_max="10"/>
										<cluster point_number="0"/>
										<event touch_event="gwTouchEnd"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="tap"/>
									<returns>
										<property id="tap_x" result="x"/>
										<property id="tap_y" result="y"/>
										<property id="tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event  type="tap">
										<property ref="tap_x"/>
										<property ref="tap_y"/>
										<property ref="tap_n"/>
									</gesture_event>
								</update>
							</mapping>
				</Gesture>					

		</Gesture_set>	
		
	<Gesture_set gesture_set_name="optimized-manipulations">
												
						<Gesture id="n-manipulate-inertia-boundary" type="manipulate">
							<match>
								<action>
									<initial>
										<cluster point_number="0" point_number_min="1" point_number_max="5"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="manipulate"/>
									<returns>
										<property id="dx" result="dx"/>
										<property id="dy" result="dy"/>
										<property id="dsx" result="ds"/>
										<property id="dsy" result="ds"/>
										<property id="dtheta" result="dtheta"/>
									</returns>
								</algorithm>
							</analysis>	
							<processing>
								<inertial_filter>
									<property ref="dx" active="true" friction="0.8"/>
									<property ref="dy" active="true" friction="0.8"/>
									<property ref="dsx" active="true" friction="0.9"/>
									<property ref="dsy" active="true" friction="0.9"/>
									<property ref="dtheta" active="true" friction="0.9"/>
								</inertial_filter>
								<delta_filter>
									<property ref="dx" active="true" delta_min="1" delta_max="100"/>
									<property ref="dy" active="true" delta_min="1" delta_max="100"/>
									<property ref="dsx" active="true" delta_min="0" delta_max="0.1"/>
									<property ref="dsy" active="true" delta_min="0" delta_max="0.1"/>
									<property ref="dtheta" active="false"/>
								</delta_filter>
								<boundary_filter>
									<property ref="dx" active="true" boundary_min="200" boundary_max="1720"/>
									<property ref="dy" active="true" boundary_min="200" boundary_max="880"/>
									<property ref="dsx" active="true" boundary_min="0.6" boundary_max="1.2"/>
									<property ref="dsy" active="true" boundary_min="0.6" boundary_max="1.2"/>
									<property ref="dtheta" active="false"/>
								</boundary_filter>
							</processing>
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event  type="manipulate">
										<property ref="dx" target="x"/>
										<property ref="dy" target="y"/>
										<property ref="dsx" target="scaleX"/>
										<property ref="dsy" target="scaleY"/>
										<property ref="dtheta" target="rotation"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
			
		</Gesture_set>
		
	<Gesture_set gesture_set_name="inertial-core-gestures">

				<Gesture id="n-drag-dial" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="drag_dx" active="true" friction=".5"/>
								<property ref="drag_dy" active="true" friction=".5"/>
							</inertial_filter>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min="0.05" delta_max="500"/>
								<property ref="drag_dy" active="true" delta_min="0.05" delta_max="500"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>		
		
				<Gesture id="n-drag-inertia" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="drag_dx" active="true" friction=".8"/>
								<property ref="drag_dy" active="true" friction=".8"/>
							</inertial_filter>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min="1" delta_max="100"/>
								<property ref="drag_dy" active="true" delta_min="1" delta_max="100"/>
							</delta_filter>
							<boundary_filter>
								<property ref="drag_dx" active="true" boundary_min="200" boundary_max="1720"/>
								<property ref="drag_dy" active="true" boundary_min="250" boundary_max="830"/>								
							</boundary_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					<Gesture id="n-rotate-inertia" type="rotate">
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="rotate"/>
								<returns>
									<property id="rotate_dtheta" result="dtheta"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="rotate_dtheta" active="true" friction="0.9"/>
							</inertial_filter>
							<delta_filter>
								<property ref="rotate_dtheta" active="true" delta_min="0.01" delta_max="20"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="rotate">
									<property ref="rotate_dtheta" target="rotate"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					<Gesture id="n-scale-inertia" type="scale">
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="scale"/>
								<returns>
									<property id="scale_dsx" result="ds"/>
									<property id="scale_dsy" result="ds"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="scale_dsx" active="true" friction="0.9"/>
								<property ref="scale_dsy" active="true" friction="0.9"/>
							</inertial_filter>
							<delta_filter>
								<property ref="scale_dsx" active="true" delta_min="0.0005" delta_max="0.5"/>
								<property ref="scale_dsy" active="true" delta_min="0.0005" delta_max="0.5"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="scale">
									<property ref="scale_dsx" target="scaleX"/>
									<property ref="scale_dsy" target="scaleY"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					
			</Gesture_set>		
			
	<Gesture_set gesture_set_name="conditonal-manipulations">
		<Gesture id="n-flick" type="flick">
			<comment>The 'n-flick' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, the velocity and 
			acceleration of the touch points are tracked. If acceleration of the cluster is above the acceleration threshold a flick event is dispatched.</comment>
			<match>
				<action>
					<initial>
						<cluster point_number="0" point_number_min="1" point_number_max="5" acceleration_min="0.5"/>
						<event touch_event="gwTouchEnd"/>
					</initial>
				</action>
			</match>
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="flick"/>
					<variables>
						<property id="flick_dx" var="etm_ddx" return="etm_dx" var_min="2"/>
						<property id="flick_dy" var="etm_ddy" return="etm_dy" var_min="2"/>
					</variables>
					<returns>
						<property id="flick_dx" result="etm_dx"/>
						<property id="flick_dy" result="etm_dy"/>
					</returns>
				</algorithm>
			</analysis>	
			<mapping>
				<update dispatch_type="discrete" dispatch_mode="cluster_remove" dispatch_reset="cluster_remove">
					<gesture_event  type="flick">
						<property ref="flick_dx" target=""/>
						<property ref="flick_dy" target=""/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
	</Gesture_set>
	
</GestureMarkupLanguage>