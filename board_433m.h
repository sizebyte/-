#ifndef board_433m_H
#define board_433m_H
//************配置*******************************
//433M数据管脚管脚
#define  SDA_PIN  P10F
#define  SDA_433  P10
//电平采样次数(电平持续时间范围)
#define BIT_1_CNT_MIN      4 // 1:400us低+1200us高  定时器定时50us
#define BIT_1_CNT_MAX      12 //
#define BIT_0_CNT_MIN      20 //0:1200us低+400us高
#define BIT_0_CNT_MAX      30 //
#define BIT_START_MIN      236 //起始位：12160ms低 
#define BIT_START_MAX      250
//遥控键值
#define  K_ON_OFF          0x2b
#define  K_MODE            0x1b
#define  K_TIMER           0x23
#define  K_NIGHT           0x0f
#define  K_LIGHT_UP        0x2a
#define  K_LIGHT_DOWN      0x22
#define  K_COLER_STOP      0x08
#define  K_COLER_RUN       0x09
extern unsigned char rf_key_value;  //键值读取接口
//************************************************
typedef union {
	unsigned long int buff;
	unsigned char value[4]; //value[3]:键值  value[0]:上一次按键键值
}DAT_433;
void board_433_init(void);//数据输入脚初始化
void RF_433m_receive_decode(void); //通过计算低电平计算数据




#endif
