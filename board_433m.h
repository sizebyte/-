#ifndef board_433m_H
#define board_433m_H
//************����*******************************
//433M���ݹܽŹܽ�
#define  SDA_PIN  P10F
#define  SDA_433  P10
//��ƽ��������(��ƽ����ʱ�䷶Χ)
#define BIT_1_CNT_MIN      4 // 1:400us��+1200us��  ��ʱ����ʱ50us
#define BIT_1_CNT_MAX      12 //
#define BIT_0_CNT_MIN      20 //0:1200us��+400us��
#define BIT_0_CNT_MAX      30 //
#define BIT_START_MIN      236 //��ʼλ��12160ms�� 
#define BIT_START_MAX      250
//ң�ؼ�ֵ
#define  K_ON_OFF          0x2b
#define  K_MODE            0x1b
#define  K_TIMER           0x23
#define  K_NIGHT           0x0f
#define  K_LIGHT_UP        0x2a
#define  K_LIGHT_DOWN      0x22
#define  K_COLER_STOP      0x08
#define  K_COLER_RUN       0x09
extern unsigned char rf_key_value;  //��ֵ��ȡ�ӿ�
//************************************************
typedef union {
	unsigned long int buff;
	unsigned char value[4]; //value[3]:��ֵ  value[0]:��һ�ΰ�����ֵ
}DAT_433;
void board_433_init(void);//��������ų�ʼ��
void RF_433m_receive_decode(void); //ͨ������͵�ƽ��������




#endif
