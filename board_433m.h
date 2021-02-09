#ifndef board_433m_H
#define board_433m_H
//************配置*******************************
//433M数据管脚管脚
#define  SDA_PIN  P15F
#define  SDA_433  P15
//电平采样次数(电平持续时间范围)
#define BIT_1_CNT_MIN      6 // 1:400us低+1200us高  定时器定时50us
#define BIT_1_CNT_MAX      12 //
#define BIT_0_CNT_MIN      20 //0:1200us低+400us高
#define BIT_0_CNT_MAX      30 //
#define BIT_START_MIN      240 //起始位：12160ms低 
#define BIT_START_MAX      255
//遥控键值
#define  KEY0            0x2b
#define  KEY1            0x1b
#define  KEY2            0x23
#define  KEY3            0x0f
#define  KEY4            0x2a
#define  KEY5            0x22
#define  KEY6            0x08
#define  KEY7            0x09
extern unsigned char rf_key_value;  //键值读取接口
//************************************************
typedef union {
	unsigned long int buff;
	unsigned char value[4]; //value[3]:键值  value[0]:上一次按键键值
}DAT_433;
void board_433_init(void);//数据输入脚初始化
void RF_433m_receive_decode(void); //通过计算低电平计算数据




#endif
