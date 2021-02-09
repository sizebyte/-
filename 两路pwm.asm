

;;r_w_pwm_data                equ     [27h]
;;r_y_pwm_data                equ     [27h]
;;r_min_pwm0                  equ     [27h]
;;r_min_pwm1                  equ     [28h]
;;r_change_data_0             equ     [29h]
;;r_change_data_1             equ     [2ah]
;;r_change_data_2             equ     [2bh]

;;**************************************
;;用nop推的pwm输出
;;**************************************
;blockname(f_nop_pwm_out)
f_nop_pwm_out:   
l_send_pwm:
	mov		a,r_change_data_0
	mov		p2,a
	mov		a,r_min_pwm0
	tbl
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	mov		a,r_change_data_1
	mov		p2,a
	mov		a,r_min_pwm1
	tbl
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	mov		a,r_change_data_2
	mov		p2,a
	ret
;blockend

;;**************************************
;;计算nop个数，两路pwm输出
;;**************************************
;blockname(f_test_temp)
f_test_temp:
	clr		rp
	mov		a,r_w_temp_timer
	mov		r_w_pwm_data,a
	mov		a,r_y_temp_timer
	mov		r_y_pwm_data,a
;;判断占空比在45~55区间,则把占空比变成	45
	mov		a,45
	sub		a,r_w_pwm_data
	sbnz	status,c
	jmp		f_test_temp_0		;;r_w_pwm_data<45
								;;r_w_pwm_data>45
	mov		a,55							
	sub		a,r_w_pwm_data
	sbz		status,c
	jmp		f_test_temp_0		;;r_w_pwm_data>55
								;;r_w_pwm_data<55	
	mov		a,45
	mov		r_w_pwm_data,a	
f_test_temp_0:
	mov		a,45
	sub		a,r_y_pwm_data
	sbnz	status,c
	jmp		f_test_temp_1		;;r_y_pwm_data<45
								;;r_y_pwm_data>45
	mov		a,55							
	sub		a,r_y_pwm_data
	sbz		status,c
	jmp		f_test_temp_1		;;r_y_pwm_data>55
								;;r_y_pwm_data<55	
	mov		a,45
	mov		r_y_pwm_data,a

f_test_temp_1:	
	mov		a,r_w_pwm_data
	or		a,r_y_pwm_data
	sbz		status,z			;;判断r_w_temp_timer和r_y_temp_timer是否为0
	jmp		l_pwm_off
	mov		a,r_w_pwm_data
	xor		a,0
	sbz		status,z
	jmp		l_all_y_set_timer	;;单黄
	mov		a,r_y_pwm_data
	xor		a,0
	sbz		status,z
	jmp		l_all_w_set_timer	;;单白
								;;黄和白
	mov		a,r_w_pwm_data
	xor		a,r_y_pwm_data
	sbz		status,z
	jmp		l_w_y_same_timer	;;白的占空比=黄的占空比
								;;白和黄两路占空比不同
	mov		a,r_w_pwm_data
	sub		a,50
	sbnz	status,c
	jmp		l_w_than_50		;;白占空比>50%
    
l_w_less_50:					;;白占空比<50%
	mov		a,r_y_pwm_data
	sub		a,50
	sbnz	status,c
	jmp		l_w_less_y_than	;;黄占空比>50%
								;;黄占空比<50%
;;===============================	
;;黄和白占空比都小于50%
l_w_y_less:
	mov		a,r_w_pwm_data
	sub		a,50
	mov		r_temp0,a
	
	mov		a,r_y_pwm_data
	sub		a,50
	mov		r_temp1,a
	mov		a,r_w_pwm_data
	sub		a,r_y_pwm_data		;;黄白相减
	sbnz	status,c
	jmp		l_w_y_less_w_max		;;黄<白
    
l_w_y_less_y_max:					;;黄>白
	di
	mov		a,r_temp0
	mov		r_min_pwm0,a
	mov		a,r_temp1
	add		a,r_w_pwm_data
	mov		r_min_pwm1,a
	mov		a,00000011b
	mov		r_change_data_0,a
	mov		a,00000010b
	mov		r_change_data_1,a
	clr		r_change_data_2
	ei
	ret
	
l_w_y_less_w_max:
	di
	mov		a,r_temp1
	mov		r_min_pwm0,a
	mov		a,r_temp0
	add		a,r_y_pwm_data
	mov		r_min_pwm1,a
	mov		a,00000011b
	mov		r_change_data_0,a
	mov		a,00000001b
	mov		r_change_data_1,a
	clr		r_change_data_2
	ei
	ret	
    
;;=============================	
;;白占空比<50%(做高nop个数),黄的占空比>50%(做低nop个数)
l_w_less_y_than:
	mov		a,r_w_pwm_data
	sub		a,50
	mov		r_temp0,a
	
	mov		a,50
	sub		a,r_y_pwm_data
	mov		r_temp1,a
	sub		a,r_temp0
	sbnz	status,c				;;判断黄和白的nop个数谁多
	jmp		l_w_less_y_than_1		;;白的nop个数多
l_w_less_y_than_0:				;;黄的nop个数多
	di
	mov		a,r_temp0
	mov		r_min_pwm0,a
	mov		a,50
	add		r_temp1,a
	mov		a,r_temp0
	sub		r_temp1,a
	mov		a,r_temp1
	mov		r_min_pwm1,a
	
	mov		a,00000001b
	mov		r_change_data_0,a
	mov		a,00000000b
	mov		r_change_data_1,a
	mov		a,00000010b
	mov		r_change_data_2,a
	ei
	ret	
l_w_less_y_than_1:
	di
	mov		a,r_temp1
	mov		r_min_pwm0,a
	mov		a,50
	add		r_temp0,a
	mov		a,r_temp1
	sub		r_temp0,a
	mov		a,r_temp0
	mov		r_min_pwm1,a
	
	mov		a,00000011b
	mov		r_change_data_0,a
	mov		a,r_y_pwm_data
	xor		a,100
	sbnz	status,z
	bclr	r_change_data_0,1
	
	mov		a,00000011b
	mov		r_change_data_1,a
	mov		a,00000010b
	mov		r_change_data_2,a
	ei
	ret	
;;================================	
	
l_w_than_50:
	mov		a,r_y_pwm_data
	sub		a,50
	sbz		status,c
	jmp		l_w_than_y_less			;;黄占空比<50%
;;===============================	;;黄占空比>50%
;;黄和白占空比都大于50%	
l_w_y_than:
	mov		a,50
	sub		a,r_w_pwm_data
	mov		r_temp0,a
	mov		a,50
	sub		a,r_y_pwm_data
	mov		r_temp1,a
	sub		a,r_temp0
	sbnz	status,c				;;判断黄和白执行的nop个数谁多
	jmp		l_w_y_than_1			;;白的nop个数多
l_w_y_than_0:						;;黄的nop个数多
	di
	mov		a,r_temp0
	mov		r_min_pwm0,a
	mov		a,50
	add		r_temp1,a
	mov		a,r_temp0
	sub		a,r_temp1
	mov		r_min_pwm1,a
	mov		a,00000000b
	mov		r_change_data_0,a
	mov		a,00000001b
	mov		r_change_data_1,a
	mov		a,00000011b
	mov		r_change_data_2,a
	ei
	ret	
l_w_y_than_1:
	di
	mov		a,r_temp1
	mov		r_min_pwm0,a
	mov		a,50
	add		r_temp0,a
	mov		a,r_temp1
	sub		a,r_temp0
	mov		r_min_pwm1,a
	mov		a,00000000b
	mov		r_change_data_0,a
	mov		a,00000010b
	mov		r_change_data_1,a
	mov		a,00000011b
	mov		r_change_data_2,a
	ei
	ret
	
;;================================	
;;白占空比>50%,黄的占空比<50%	
l_w_than_y_less:
	mov		a,r_y_pwm_data
	sub		a,50
	mov		r_temp0,a
	
	mov		a,50
	sub		a,r_w_pwm_data
	mov		r_temp1,a
	sub		a,r_temp0
	sbnz	status,c
	jmp		l_w_than_y_less_1		;;黄的nop个数多
l_w_than_y_less_0:              	;;白的nop个数多
	di
	mov		a,r_temp0
	mov		r_min_pwm0,a
	mov		a,50
	add		r_temp1,a
	mov		a,r_temp0
	sub		r_temp1,a
	mov		a,r_temp1
	mov		r_min_pwm1,a
	
	mov		a,00000010b
	mov		r_change_data_0,a
	mov		a,00000000b
	mov		r_change_data_1,a
	mov		a,00000001b
	mov		r_change_data_2,a
	ei
	ret	
l_w_than_y_less_1:
	di
	mov		a,r_temp1
	mov		r_min_pwm0,a
	mov		a,50
	add		r_temp0,a
	mov		a,r_temp1
	sub		r_temp0,a
	mov		a,r_temp0
	mov		r_min_pwm1,a
	
	mov		a,00000011b
	mov		r_change_data_0,a
	mov		a,r_w_pwm_data
	xor		a,100
	sbnz	status,z
	bclr	r_change_data_0,0
	
	mov		a,00000011b
	mov		r_change_data_1,a
	mov		a,00000010b
	mov		r_change_data_2,a
	ei
	ret	
    
;;======================================
;;黄和白占空比相同	
l_w_y_same_timer:
	mov		a,r_w_pwm_data
	sub		a,50
	sbz		status,c
	jmp		l_w_y_same_low		;;黄和白占空比<50%
l_w_y_same_high:					;;黄和白占空比>50%
	di
	mov		a,50
	mov		r_min_pwm1,a
	mov		a,50
	sub		a,r_w_pwm_data
	mov		r_min_pwm0,a
	
	mov		a,00000011b
	mov		r_change_data_0,a
	mov		a,r_y_pwm_data
	xor		a,100
	sbnz	status,z
	clr		r_change_data_0
	
	mov		a,00000011b
	mov		r_change_data_1,a
	mov		a,00000011b
	mov		r_change_data_2,a
	ei
	ret	
	
l_w_y_same_low:
	di
	mov		a,50
	mov		r_min_pwm1,a
	mov		a,r_y_pwm_data
	sub		a,50
	mov		r_min_pwm0,a
	
	mov		a,00000011b
	mov		r_change_data_0,a
	mov		a,00000000b
	mov		r_change_data_1,a
	mov		a,00000000b
	mov		r_change_data_2,a	
	ei
	ret	
	

l_pwm_off:
	bclr	p2,1
	bclr	p2,0
	mov		a,50
	mov		r_min_pwm0,a
	mov		r_min_pwm1,a
	clr		r_change_data_0
	clr		r_change_data_1
	clr		r_change_data_2
	ret
    
l_y_max_w_no:
	mov		a,50
	mov		r_min_pwm0,a
	mov		r_min_pwm1,a
	mov		a,00000010b
	mov		r_change_data_0,a
	mov		r_change_data_1,a
	mov		r_change_data_2,a
	ret		
l_w_max_y_no:
	mov		a,50
	mov		r_min_pwm0,a
	mov		r_min_pwm1,a
	mov		a,00000001b
	mov		r_change_data_0,a
	mov		r_change_data_1,a
	mov		r_change_data_2,a
	ret		
;;单黄    
l_all_y_set_timer:
	mov		a,r_y_pwm_data
	xor		a,100
	sbz		status,z
	jmp		l_y_max_w_no			;;100%占空比
	mov		a,r_y_pwm_data
	sub		a,50
	sbnz	status,c
	jmp		l_y_max_half			;;占空比>50%
									;;占空比<50%

	di
	mov		a,r_y_pwm_data
	sub		a,50
	mov		r_min_pwm0,a
	mov		a,50
	mov		r_min_pwm1,a	

	mov		a,00000010b
	mov		r_change_data_0,a
	mov		a,00000000b
	mov		r_change_data_1,a
	mov		a,00000000b
	mov		r_change_data_2,a
	ei
	ret
    
l_y_max_half:
	di
	mov		a,50
	mov		r_min_pwm1,a	
	mov		a,50
	sub		a,r_y_pwm_data
	mov		r_min_pwm0,a
	
	mov		a,00000000b
	mov		r_change_data_0,a
	mov		a,00000010b
	mov		r_change_data_1,a
	mov		a,00000010b
	mov		r_change_data_2,a
	ei
	ret	
;;单白	
l_all_w_set_timer:
	mov		a,r_w_pwm_data
	xor		a,100
	sbz		status,z
	jmp		l_w_max_y_no         ;;100%占空比
	mov		a,r_w_pwm_data     
	sub		a,50                   
	sbnz	status,c             
	jmp		l_w_max_half         ;;占空比>50%
								   ;;占空比<50%
	di							   
	mov		a,50                   
	mov		r_min_pwm1,a	
	mov		a,r_w_pwm_data
	sub		a,50
	mov		r_min_pwm0,a
	
	mov		a,00000001b
	mov		r_change_data_0,a
	mov		a,00000000b
	mov		r_change_data_1,a
	mov		a,00000000b
	mov		r_change_data_2,a
	ei
	ret
    
l_w_max_half:
	di
	mov		a,50
	mov		r_min_pwm1,a	
	mov		a,50
	sub		a,r_w_pwm_data
	mov		r_min_pwm0,a
	
	mov		a,00000000b
	mov		r_change_data_0,a
	mov		a,00000001b
	mov		r_change_data_1,a
	mov		a,00000001b
	mov		r_change_data_2,a
	ei
	ret
;blockend   


    
;;**************************************
;;呼吸输出
;;**************************************    
;blockname (f_breathe_output)
f_breathe_output:

    sdz		r_pwm_total_timer				;;pwm总的时间
    jmp     l_breathe_output_step0
	
    mov     a, 200							;;给pwm总时间赋值
    mov     r_pwm_total_timer, a

    mov     a, r_pwm_hight_timer			;;给pwm高电平时间赋值
    mov     r_pwm_temp_timer, a
    sbnz    status, z
    bclr    P2, 0                			;;指示灯亮
    ret 
l_breathe_output_step0:
    sdz		r_pwm_temp_timer		;;r_pwm_temp_timer--,若为0则跳过下一次指令
    ret
    bst     P2, 0							;;指示灯灭
    ret	
	
;blockend    


;;*****************************************************
;;功    能：恒定化和最大化
;;			黄白两路色温的占空比,计数出各自输出的pwm值
;;输入参数：
;;输出参数
;;*****************************************************
;callname  (f_pwm_calculate)
;;pwm计算
f_pwm_calculate:

;blockname (f_pwm_constant)
;;pwm恒定化
f_pwm_constant:
	sbnz	r_led_flag, b_led_on        	;;开灯标志位,1:表示开灯,0:表示关灯
	ret                                 	;;机状态，返回	
	bclr	status,c
	SLC		r_sewen_level		;;左移*2
	SLC		r_sewen_level		;;左移*2
	SLC		r_sewen_level		;;左移*2
	SLC		r_sewen_level		;;左移*2
	mov		a, r_sewen_level
	m_bank1
	mov		[mul0],a			;;乘数
	clr		[mul1]
	m_bank0
	mov		a, r_light_value				;;当前黄白两路亮度值的总数,值是可变,根据亮度的加减
	m_bank1
	mov		[bmul0],a			;;被乘数
	clr		[bmul1]
	
	call	mul2x2				;;乘法

	mov		a,[result0]			;;结果
	mov		[dividend0],a		;;被除数
	mov		a,[result1]
	mov		[dividend1],a
	mov		a,[result2]
	mov		[dividend2],a
	mov		a,[result3]
	mov		[dividend3],a
	
	mov		a, c_sewen_total	;;色温的总占空比比例
	mov		[divisor0],a		;;除数寄存器
	clr		[divisor1]	
	
	call	div4I2				;;除法
	  
	mov		a,[result0]			;;结果
;;白光的pwm值=r_sewen_level*r_light_value/c_sewen_total    
	M_bank0
	mov		r_w_temp_to_timer,a		;;白灯pwm值
;;	mov		r_w_temp_timer,a		;;白灯pwm值	
 
	sub		a, r_light_value	
	sbnz	status,c
	jmp		l_pwm_constant_step0
;;黄光的pwm值=r_light_value-r_w_temp_to_timer	
	mov		r_y_temp_to_timer,a		;;黄灯pwm值
;;	mov		r_y_temp_timer,a		;;黄灯pwm值
    ret
l_pwm_constant_step0:
	mov		a, r_light_value
	sub		a, r_w_temp_to_timer
	mov		r_y_temp_to_timer, a
    ret
;blockend

;blockname (f_pwm_maximize)
;;;;pwm最大化
;;f_pwm_maximize:
;;	m_bank1
;;	mov		[mul0],a			;;乘数
;;	clr		[mul1]
;;	m_bank0
;;	mov		a, C_PWM_FREQU		;;pwm总数值
;;	m_bank1
;;	mov		[bmul0],a			;;被乘数
;;	clr		[bmul1]
;;	
;;	call	mul2x2				;;乘法运算程序
;;
;;	mov		a,[result0]			;;结果
;;	mov		[dividend0],a		;;被除数
;;	mov		a,[result1]
;;	mov		[dividend1],a
;;	mov		a,[result2]
;;	mov		[dividend2],a
;;	mov		a,[result3]
;;	mov		[dividend3],a
;;	
;;	mov		a, 130				;;亮度的总占空比比例
;;	mov		[divisor0],a		;;除数寄存器
;;	clr		[divisor1]	
;;	
;;	call	div4I2				;;除法运算程序
;;	  
;;	mov		a,[result0]		;;结果
;;r_led_temp_light_value=r_light_level*C_PWM_FREQU/130    
;;	M_bank0
;;	mov		r_led_temp_light_value,a	
;;通过亮度档位r_light_level,计算出当前的总亮度值r_led_temp_light_value
;;通过色温档位r_sewen_level,计算出白黄两路各自的亮度值
;blockend
	
;callend



