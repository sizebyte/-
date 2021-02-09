#include "board_433m.h"
#include "WS51F7030.h"
unsigned char rf_key_value;
void board_433_init(void)
{
	GPIO_Init(SDA_PIN,INPUT|PUL_EN);
}
void RF_433m_receive_decode(void) //ͨ������͵�ƽ��������
{
	static bit f_start=0;
	static bit f_first_in;
	static DAT_433 rf_433m;
	static unsigned char bit_cnt;
    static unsigned char io_0_timer_cnt;	
	if(SDA_433==1){
		if(f_first_in==0){
		    f_first_in=1;
			if(f_start==0){      			
                if(io_0_timer_cnt>BIT_START_MIN&&io_0_timer_cnt<BIT_START_MAX){ //��ʼλ
					bit_cnt=0;
					f_start=1;
		        }
				else {   //�ɿ�״̬
					 f_start=0;
					 rf_433m.buff= 0;
                     rf_key_value=0;					
					}
			}
			else{	
		        rf_433m.buff =rf_433m.buff<<1;
				bit_cnt++;					
				if(io_0_timer_cnt>BIT_1_CNT_MIN && io_0_timer_cnt<BIT_1_CNT_MAX){ //bitλΪ1
			       rf_433m.buff ++;								
		        }
				else if(io_0_timer_cnt<BIT_0_CNT_MIN && io_0_timer_cnt>BIT_0_CNT_MAX) {//���Ƿ���0��1��ʱ�䷶Χ
					f_start=0;
					rf_433m.buff&=0xff000000;
				}
		        if(bit_cnt==24){
					f_start=0;
			       if(rf_433m.value[0]==rf_433m.value[3]) 
					   rf_key_value= rf_433m.value[3];
			    }			
			}
		io_0_timer_cnt=0;
		}
	}
	else{  //�ܽ�Ϊ�͵�ƽ
		io_0_timer_cnt++;
		f_first_in=0;
	}
}









