#ifndef board_433m_H
#define board_433m_H
//************����*******************************
//433M���ݹܽŹܽ�
#define  SDA_PIN  P15F
#define  SDA_433  P15
//��ƽ��������(��ƽ����ʱ�䷶Χ)
#define BIT_1_CNT_MIN      6 // 1:400us��+1200us��  ��ʱ����ʱ50us
#define BIT_1_CNT_MAX      12 //
#define BIT_0_CNT_MIN      20 //0:1200us��+400us��
#define BIT_0_CNT_MAX      30 //
#define BIT_START_MIN      240 //��ʼλ��12160ms�� 
#define BIT_START_MAX      255
//ң�ؼ�ֵ
#define  KEY0            0x2b
#define  KEY1            0x1b
#define  KEY2            0x23
#define  KEY3            0x0f
#define  KEY4            0x2a
#define  KEY5            0x22
#define  KEY6            0x08
#define  KEY7            0x09
extern unsigned char rf_key_value;  //��ֵ��ȡ�ӿ�
//************************************************
typedef union {
	unsigned long int buff;
	unsigned char value[4]; //value[3]:��ֵ  value[0]:��һ�ΰ�����ֵ
}DAT_433;
void board_433_init(void);//��������ų�ʼ��
void RF_433m_receive_decode(void); //ͨ������͵�ƽ��������




#endif
