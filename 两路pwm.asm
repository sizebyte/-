

;;r_w_pwm_data                equ     [27h]
;;r_y_pwm_data                equ     [27h]
;;r_min_pwm0                  equ     [27h]
;;r_min_pwm1                  equ     [28h]
;;r_change_data_0             equ     [29h]
;;r_change_data_1             equ     [2ah]
;;r_change_data_2             equ     [2bh]

;;**************************************
;;��nop�Ƶ�pwm���
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
;;����nop��������·pwm���
;;**************************************
;blockname(f_test_temp)
f_test_temp:
	clr		rp
	mov		a,r_w_temp_timer
	mov		r_w_pwm_data,a
	mov		a,r_y_temp_timer
	mov		r_y_pwm_data,a
;;�ж�ռ�ձ���45~55����,���ռ�ձȱ��	45
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
	sbz		status,z			;;�ж�r_w_temp_timer��r_y_temp_timer�Ƿ�Ϊ0
	jmp		l_pwm_off
	mov		a,r_w_pwm_data
	xor		a,0
	sbz		status,z
	jmp		l_all_y_set_timer	;;����
	mov		a,r_y_pwm_data
	xor		a,0
	sbz		status,z
	jmp		l_all_w_set_timer	;;����
								;;�ƺͰ�
	mov		a,r_w_pwm_data
	xor		a,r_y_pwm_data
	sbz		status,z
	jmp		l_w_y_same_timer	;;�׵�ռ�ձ�=�Ƶ�ռ�ձ�
								;;�׺ͻ���·ռ�ձȲ�ͬ
	mov		a,r_w_pwm_data
	sub		a,50
	sbnz	status,c
	jmp		l_w_than_50		;;��ռ�ձ�>50%
    
l_w_less_50:					;;��ռ�ձ�<50%
	mov		a,r_y_pwm_data
	sub		a,50
	sbnz	status,c
	jmp		l_w_less_y_than	;;��ռ�ձ�>50%
								;;��ռ�ձ�<50%
;;===============================	
;;�ƺͰ�ռ�ձȶ�С��50%
l_w_y_less:
	mov		a,r_w_pwm_data
	sub		a,50
	mov		r_temp0,a
	
	mov		a,r_y_pwm_data
	sub		a,50
	mov		r_temp1,a
	mov		a,r_w_pwm_data
	sub		a,r_y_pwm_data		;;�ư����
	sbnz	status,c
	jmp		l_w_y_less_w_max		;;��<��
    
l_w_y_less_y_max:					;;��>��
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
;;��ռ�ձ�<50%(����nop����),�Ƶ�ռ�ձ�>50%(����nop����)
l_w_less_y_than:
	mov		a,r_w_pwm_data
	sub		a,50
	mov		r_temp0,a
	
	mov		a,50
	sub		a,r_y_pwm_data
	mov		r_temp1,a
	sub		a,r_temp0
	sbnz	status,c				;;�жϻƺͰ׵�nop����˭��
	jmp		l_w_less_y_than_1		;;�׵�nop������
l_w_less_y_than_0:				;;�Ƶ�nop������
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
	jmp		l_w_than_y_less			;;��ռ�ձ�<50%
;;===============================	;;��ռ�ձ�>50%
;;�ƺͰ�ռ�ձȶ�����50%	
l_w_y_than:
	mov		a,50
	sub		a,r_w_pwm_data
	mov		r_temp0,a
	mov		a,50
	sub		a,r_y_pwm_data
	mov		r_temp1,a
	sub		a,r_temp0
	sbnz	status,c				;;�жϻƺͰ�ִ�е�nop����˭��
	jmp		l_w_y_than_1			;;�׵�nop������
l_w_y_than_0:						;;�Ƶ�nop������
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
;;��ռ�ձ�>50%,�Ƶ�ռ�ձ�<50%	
l_w_than_y_less:
	mov		a,r_y_pwm_data
	sub		a,50
	mov		r_temp0,a
	
	mov		a,50
	sub		a,r_w_pwm_data
	mov		r_temp1,a
	sub		a,r_temp0
	sbnz	status,c
	jmp		l_w_than_y_less_1		;;�Ƶ�nop������
l_w_than_y_less_0:              	;;�׵�nop������
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
;;�ƺͰ�ռ�ձ���ͬ	
l_w_y_same_timer:
	mov		a,r_w_pwm_data
	sub		a,50
	sbz		status,c
	jmp		l_w_y_same_low		;;�ƺͰ�ռ�ձ�<50%
l_w_y_same_high:					;;�ƺͰ�ռ�ձ�>50%
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
;;����    
l_all_y_set_timer:
	mov		a,r_y_pwm_data
	xor		a,100
	sbz		status,z
	jmp		l_y_max_w_no			;;100%ռ�ձ�
	mov		a,r_y_pwm_data
	sub		a,50
	sbnz	status,c
	jmp		l_y_max_half			;;ռ�ձ�>50%
									;;ռ�ձ�<50%

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
;;����	
l_all_w_set_timer:
	mov		a,r_w_pwm_data
	xor		a,100
	sbz		status,z
	jmp		l_w_max_y_no         ;;100%ռ�ձ�
	mov		a,r_w_pwm_data     
	sub		a,50                   
	sbnz	status,c             
	jmp		l_w_max_half         ;;ռ�ձ�>50%
								   ;;ռ�ձ�<50%
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
;;�������
;;**************************************    
;blockname (f_breathe_output)
f_breathe_output:

    sdz		r_pwm_total_timer				;;pwm�ܵ�ʱ��
    jmp     l_breathe_output_step0
	
    mov     a, 200							;;��pwm��ʱ�丳ֵ
    mov     r_pwm_total_timer, a

    mov     a, r_pwm_hight_timer			;;��pwm�ߵ�ƽʱ�丳ֵ
    mov     r_pwm_temp_timer, a
    sbnz    status, z
    bclr    P2, 0                			;;ָʾ����
    ret 
l_breathe_output_step0:
    sdz		r_pwm_temp_timer		;;r_pwm_temp_timer--,��Ϊ0��������һ��ָ��
    ret
    bst     P2, 0							;;ָʾ����
    ret	
	
;blockend    


;;*****************************************************
;;��    �ܣ��㶨�������
;;			�ư���·ɫ�µ�ռ�ձ�,���������������pwmֵ
;;���������
;;�������
;;*****************************************************
;callname  (f_pwm_calculate)
;;pwm����
f_pwm_calculate:

;blockname (f_pwm_constant)
;;pwm�㶨��
f_pwm_constant:
	sbnz	r_led_flag, b_led_on        	;;���Ʊ�־λ,1:��ʾ����,0:��ʾ�ص�
	ret                                 	;;��״̬������	
	bclr	status,c
	SLC		r_sewen_level		;;����*2
	SLC		r_sewen_level		;;����*2
	SLC		r_sewen_level		;;����*2
	SLC		r_sewen_level		;;����*2
	mov		a, r_sewen_level
	m_bank1
	mov		[mul0],a			;;����
	clr		[mul1]
	m_bank0
	mov		a, r_light_value				;;��ǰ�ư���·����ֵ������,ֵ�ǿɱ�,�������ȵļӼ�
	m_bank1
	mov		[bmul0],a			;;������
	clr		[bmul1]
	
	call	mul2x2				;;�˷�

	mov		a,[result0]			;;���
	mov		[dividend0],a		;;������
	mov		a,[result1]
	mov		[dividend1],a
	mov		a,[result2]
	mov		[dividend2],a
	mov		a,[result3]
	mov		[dividend3],a
	
	mov		a, c_sewen_total	;;ɫ�µ���ռ�ձȱ���
	mov		[divisor0],a		;;�����Ĵ���
	clr		[divisor1]	
	
	call	div4I2				;;����
	  
	mov		a,[result0]			;;���
;;�׹��pwmֵ=r_sewen_level*r_light_value/c_sewen_total    
	M_bank0
	mov		r_w_temp_to_timer,a		;;�׵�pwmֵ
;;	mov		r_w_temp_timer,a		;;�׵�pwmֵ	
 
	sub		a, r_light_value	
	sbnz	status,c
	jmp		l_pwm_constant_step0
;;�ƹ��pwmֵ=r_light_value-r_w_temp_to_timer	
	mov		r_y_temp_to_timer,a		;;�Ƶ�pwmֵ
;;	mov		r_y_temp_timer,a		;;�Ƶ�pwmֵ
    ret
l_pwm_constant_step0:
	mov		a, r_light_value
	sub		a, r_w_temp_to_timer
	mov		r_y_temp_to_timer, a
    ret
;blockend

;blockname (f_pwm_maximize)
;;;;pwm���
;;f_pwm_maximize:
;;	m_bank1
;;	mov		[mul0],a			;;����
;;	clr		[mul1]
;;	m_bank0
;;	mov		a, C_PWM_FREQU		;;pwm����ֵ
;;	m_bank1
;;	mov		[bmul0],a			;;������
;;	clr		[bmul1]
;;	
;;	call	mul2x2				;;�˷��������
;;
;;	mov		a,[result0]			;;���
;;	mov		[dividend0],a		;;������
;;	mov		a,[result1]
;;	mov		[dividend1],a
;;	mov		a,[result2]
;;	mov		[dividend2],a
;;	mov		a,[result3]
;;	mov		[dividend3],a
;;	
;;	mov		a, 130				;;���ȵ���ռ�ձȱ���
;;	mov		[divisor0],a		;;�����Ĵ���
;;	clr		[divisor1]	
;;	
;;	call	div4I2				;;�����������
;;	  
;;	mov		a,[result0]		;;���
;;r_led_temp_light_value=r_light_level*C_PWM_FREQU/130    
;;	M_bank0
;;	mov		r_led_temp_light_value,a	
;;ͨ�����ȵ�λr_light_level,�������ǰ��������ֵr_led_temp_light_value
;;ͨ��ɫ�µ�λr_sewen_level,������׻���·���Ե�����ֵ
;blockend
	
;callend



