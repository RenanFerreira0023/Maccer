//+------------------------------------------------------------------+
//|                                                 OATM COPY TRADER sv.mq5 |
//|                        Copyright 14/04/23,                     . |
//|                            Developer,         Renan D. Ferreira. |
//|                            Analyst,                  Igor Mello. |
//|                                                                  |
//|                   rdstraderprofissional@gmail.com                |
//|                                OU                                |
//|                    NOS SIGA NO INSTAGRAM [  @RDSTRADER_  ]       |
//|                                                                  |
//|                                                    OATM COPY TRADER sv  |
//+------------------------------------------------------------------+
#property copyright "Renan Dutra Ferreira"
#property link      "https://www.mql5.com/en/users/renandutra/"
#property description "@_fdutra | appsskilldeveloper@gmail.com ";
#define VERSION "1.0"
#property version VERSION
#define NAME_BOT "RDS COPY AGENT"
#property icon "ico.ico"
#include <JAson.mqh>







bool static YES   = true;
bool static NO    = false;

int static UNLOCK = 0;
int static LOCK   = 1;


//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|  CONFIGURAÇÃO CONTA DEMO                                         |
//|                                                                  |
//|                                                                  |
bool ENTRY_LOCK = false;
int LOCKED_REAL_MODE = 0;                    // ~~~~  CONFIGURAÇÃO DO CONTROLE DE CONTA ( 0 = demo e real | 1 = somente demo | 2 = somente real )
datetime dtStart = D'2020.01.01 08:00';      // ~~~~ CONFIGURAÇÃO DE DATA INICIO DA CONTA DEMO
datetime dtEnd = D'2053.07.01 08:15';        // ~~~~ CONFIGURAÇÃO DE DATA FIM DA CONTA DEMO
int daysForAlertDiary = 3;                  // ~~~~ ALERTA DIÁRIOS QUANDO FALTAR X DIAS PARA ENCERRAR A CONTA DEMO
ulong static accountFree[] =
  {
   334628,                                   //~~~~~~ renan genial
   5196121,                               //~~~~~~ renan deriv
   12783,
// .. 33333333,
// .. 44444444,
// .. 555555555,
   50604243,                                  //~~~~~~ renan icmarket
   1098020929,                               //ftmo desafio
   41770274,                                 //~~ Jaime
   944894

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string demo_module2()
  {

   if(LOCKED_REAL_MODE == 1) // 1 = somente demo
      if((MQLInfoInteger(MQL_TESTER)
          || MQLInfoInteger(MQL_DEBUG)
          || MQLInfoInteger(MQL_PROFILER)
          || MQLInfoInteger(MQL_FORWARD)
          || MQLInfoInteger(MQL_OPTIMIZATION)
          || MQLInfoInteger(MQL_VISUAL_MODE))
        )
         return NAME_BOT+" v"+VERSION+"\n COPIA LIBERADA SOLO PARA ENTORNO DE PRUEBA.";

   if(LOCKED_REAL_MODE == 2) // 2 = somente real
      if(!(MQLInfoInteger(MQL_TESTER)
           || MQLInfoInteger(MQL_DEBUG)
           || MQLInfoInteger(MQL_PROFILER)
           || MQLInfoInteger(MQL_FORWARD)
           || MQLInfoInteger(MQL_OPTIMIZATION)
           || MQLInfoInteger(MQL_VISUAL_MODE))
        )
         return NAME_BOT+" v"+VERSION+"\n COPIA LIBERADA ÚNICAMENTE PARA ENTORNO DE PRODUCCIÓN..";

   datetime dtNow = TimeCurrent();



   double timeDifference = dtEnd - TimeCurrent();
   int daysRest = (int)MathRound(timeDifference/86400);
   if(daysRest <= daysForAlertDiary)
     {
      string msg =  "Quedan "+daysRest +" días hasta el final de su cuenta demo!";

      if(lockedDemo == UNLOCK)
        {
         Alert(msg);
         Comment(msg);
         Print(msg);
         lockedDemo  = LOCK;
        }
     }
//   if(valid_number_account() == LOCK)
//      return NAME_BOT+" v"+VERSION+"\n CUENTA NO AUTORIZADA PARA ESTA COPIA.";

   if(dtNow > dtEnd)
      return NAME_BOT+" v"+VERSION+"\nDemo terminado, Gracias :) ";
   else
     {
      if(MQLInfoInteger(MQL_TESTER))
        {
         datetime dtNow = TimeCurrent();


         if(dtNow < dtEnd &&
            dtNow > dtStart)
            return "";
         else
            return NAME_BOT+" v"+VERSION+"\nDemo terminado, Gracias :) ";
        }
      return "";
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int valid_number_account()
  {
   long loginAccount = AccountInfoInteger(ACCOUNT_LOGIN);
   for(int i = 0; i < ArraySize(accountFree) ; i++)
      if(accountFree[i] == loginAccount)
         return UNLOCK;
   return LOCK;
  }

//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string demo_module()
  {

   if(KEY_FLOW_GLOBAL ==  LOCK)
      return "Chave não autenticada";
   else
      return "";
  }



#include <Controls\WndClient.mqh>
#include <Controls\Dialog.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>
#include <Controls\ComboBox.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Picture.mqh>



//--- макросы для работы с цветом
#define XRGB(r,g,b)    (0xFF000000 | (uchar(r) << 16) | (uchar(g) << 8) | uchar(b) )
#define GETRGB(clr)    ((clr)&0xFFFFFF )

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//--- indents and gaps

#define              MARGEM_ESQUERDA                          (5)
#define              MARGEM_TOPO                              (10)
#define              ALTURA                                   (20)
#define              TAMANHO_EDIT_DIREITA                     (100)

#define              FONT_NAME                                (11.5)




color colorTitle = clrWhite;
//color colorBackGroud = C'219,219,219';
color colorDivisorBG = C'107,107,107';
color colorDivisorBorder = C'82,82,82';

color colorSquereOn = clrMediumSeaGreen;
color colorSquereOff = clrDimGray;


color colorProfitPositive = C'54,98,201';
color colorProfitNegative = C'255,85,85';
color colorProfitOff = C'139,139,139';



color colorBorderBuy = C'12,81,209';
color colorBackgroundBuy = C'62,129,253';
color colorTextBuy = clrBlack;

color colorBorderSell = C'213,0,0';
color colorBackgroundSell = C'185,0,0';
color colorTextSell = C'196,196,196';




color colorBorderBuyPeddin = C'12,81,209';
color colorBackgroundBuyPeddin = C'0,166,221';
color colorTextBuyPeddin = clrBlack;

color colorBorderSellPeddin = C'213,0,0';
color colorBackgroundSellPeddin = C'198,54,0';
color colorTextSellPeddin = C'196,196,196';


//+------------------------------------------------------------------+
//| Class CMyWndClient                                               |
//| Usage: main dialog of the Controls application                   |
//+------------------------------------------------------------------+
class CMyWndClient : public CWndClient
  {
private:

   CAppDialog        m_owner;                         // owner
   CPanel            m_backgroud_main;
   CLabel            m_title_main;

   CLabel            m_title_lot;
   CEdit             m_edit_lot;

   CLabel            m_title_converting;
   CComboBox         m_cbx_converting;

   CLabel            m_title_stoploss;
   CEdit             m_edit_stoploss;

   CLabel            m_title_takeprofit;
   CEdit             m_edit_takeprofit;

   CPanel            m_squere_status;
   CLabel            m_title_on_operation;

   CLabel            m_title_eto;
   CButton           m_button_eto;
   CLabel            m_info_position_current;

   CPanel            m_divisor_horizontal_1;

   CButton           m_btn_add_alert;
   CComboBox         m_cbx_position_alert;

   CPanel            m_divisor_horizontal_2;

   CButton           m_btn_buy;
   CButton           m_btn_pedding_buy;
   CButton           m_btn_sell;
   CButton           m_btn_pedding_sell;


   CPicture          m_picture;
protected:
   bool              CreateTitle(const color clrTxtTile);
   color             GetRandomColor();
   void              ColorCaption(const color clr);

   double            return_value_converting(double price);


public:
                     CMyWndClient(void);
                    ~CMyWndClient(void);
   CRect             GetClientRect(const CWndContainer *obj);
   bool              Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   //   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

   void              set_name_version(string nameVersion);

   void              set_lot(string value);
   double            get_lot();

   void              set_converting(int value);
   int               get_converting();

   void              set_value_stoploss(string value);
   double            get_value_stoploss(bool pure);

   void              set_value_takeprofit(string value);
   double            get_value_takeprofit(bool pure);

   void              set_status_position(int status);

   void              set_text_status_position(string textStatus);

   void              set_eto_profit(double profit);

   int               get_direction_alert();


  };




//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMyWndClient::CMyWndClient(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMyWndClient::~CMyWndClient(void)
  {
  }




//+------------------------------------------------------------------+
//| Получение размеров доступного пространства в контейнере          |
//+------------------------------------------------------------------+
CRect CMyWndClient::GetClientRect(const CWndContainer *obj)
  {
   CRect rect;
   rect.Size(1,1); // initialization variable 'rect'
//--- 
   int total=obj.ControlsTotal();
   for(int i=0; i<total; i++)
     {
      CWnd*cwnd_obj=obj.Control(i);
      string name=cwnd_obj.Name();
      //--- get Rect
      if(StringFind(name,"Client")>0)
        {
         CWndClient *client=(CWndClient*)cwnd_obj;
         rect=client.Rect();
        }
     }
   return (rect);
  }

//+------------------------------------------------------------------+
//| Устанавливает цвет заголовка                                     |
//+------------------------------------------------------------------+
void CMyWndClient::ColorCaption(const color clr)
  {
   int total=m_owner.ControlsTotal();
   Print("total      "+total);
   for(int i=0; i<total; i++)
     {
      CWnd*obj=m_owner.Control(i);
      string prefix=m_owner.Name();
      string name=obj.Name();
      //---

      if(StringFind(name,prefix+"Caption")!=-1)
        {
         CEdit *edit=(CEdit*) obj;
         edit.ColorBackground(clr);
         ChartRedraw();
         return;
        }
     }
  }




//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CMyWndClient::Create(const long chart,const string name, int subwin, int x1, int y1, int x2, int y2)
  {

   if(!CWndClient::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);










   x1 = (0);
   y1 = (0);
   x2 = 200  ;
   y2 = 150;

   if(!m_picture.Create(m_chart_id,m_name+"m_picture",m_subwin,x1,y1,x2,y2))
      return(false);
//--- definimos o nome dos arquivos bmp para exibir os controles CPicture
   m_picture.BmpName(".\\LOGO_OATM.bmp");
//   m_picture.BmpName("\\Images\\LOGO_RDS_COPY_TRADER.bmp");

   if(!Add(m_picture))
      return(false);




   x1 = (MARGEM_ESQUERDA * 5);
   y1 = (MARGEM_TOPO * 0.5);
   x2 = x1 + 130;
   y2 = y1 + ALTURA;
   if(!m_title_main.Create(m_chart_id,m_name+"m_title_main",m_subwin,x1,y1,x2,y2))
      return(false);
   m_title_main.FontSize(FONT_NAME);
   m_title_main.Color(colorTitle);

   if(!m_title_main.Text("RDS COPY AGENT v"))
      return(false);
   if(!Add(m_title_main))
      return(false);



   x1 = (MARGEM_ESQUERDA * 3);
   y1 = (MARGEM_TOPO * 2.5);
   x2 = x1 + 55;
   y2 = y1 + ALTURA;
   if(!m_title_lot.Create(m_chart_id,m_name+"m_title_lot",m_subwin,x1,y1,x2,y2))
      return(false);
   m_title_lot.FontSize(FONT_NAME);
   m_title_lot.Color(colorTitle);

   if(!m_title_lot.Text("Lote"))
      return(false);
   if(!Add(m_title_lot))
      return(false);



   x1 = (MARGEM_ESQUERDA * 25);
   y1 = (MARGEM_TOPO * 2.5);
   x2 = x1 + 100;
   y2 = y1 + ALTURA;
   if(!m_edit_lot.Create(m_chart_id,m_name+"m_edit_lot",m_subwin,x1,y1,x2,y2))
      return(false);
   m_edit_lot.FontSize(FONT_NAME);
   m_edit_lot.Color(clrBlack);
   m_edit_lot.TextAlign(ALIGN_CENTER);
   if(!m_edit_lot.Text("0.01"))
      return(false);
   if(!Add(m_edit_lot))
      return(false);


   x1 = (MARGEM_ESQUERDA * 3);
   y1 = (MARGEM_TOPO * 5);
   x2 = x1 + 90;
   y2 = y1 + ALTURA;
   if(!m_title_converting.Create(m_chart_id,m_name+"m_title_converting",m_subwin,x1,y1,x2,y2))
      return(false);
   m_title_converting.FontSize(FONT_NAME);
   m_title_converting.Color(colorTitle);

   if(!m_title_converting.Text("Conversão"))
      return(false);
   if(!Add(m_title_converting))
      return(false);



   x1 = (MARGEM_ESQUERDA * 25);
   y1 = (MARGEM_TOPO * 5);
   x2 = x1 + 100;
   y2 = y1 + ALTURA;
   if(!m_cbx_converting.Create(m_chart_id,m_name+"m_cbx_converting",m_subwin,x1,y1,x2,y2))
      return(false);

   m_cbx_converting.AddItem("Pips",0);
   m_cbx_converting.AddItem("Ticks",1);
   m_cbx_converting.AddItem("Pontos",2);
   m_cbx_converting.Select(0);
   if(!Add(m_cbx_converting))
      return(false);




   x1 = (MARGEM_ESQUERDA * 3);
   y1 = (MARGEM_TOPO * 7.5);
   x2 = x1 + 90;
   y2 = y1 + ALTURA;
   if(!m_title_stoploss.Create(m_chart_id,m_name+"m_title_stoploss",m_subwin,x1,y1,x2,y2))
      return(false);
   m_title_stoploss.FontSize(FONT_NAME);
   m_title_stoploss.Color(colorTitle);

   if(!m_title_stoploss.Text("StopLoss"))
      return(false);
   if(!Add(m_title_stoploss))
      return(false);





   x1 = (MARGEM_ESQUERDA * 25);
   y1 = (MARGEM_TOPO * 7.5);
   x2 = x1 + 100;
   y2 = y1 + ALTURA;
   if(!m_edit_stoploss.Create(m_chart_id,m_name+"m_edit_stoploss",m_subwin,x1,y1,x2,y2))
      return(false);
   m_edit_stoploss.FontSize(FONT_NAME);
   m_edit_stoploss.Color(clrBlack);
   m_edit_stoploss.TextAlign(ALIGN_CENTER);
   if(!m_edit_stoploss.Text("150"))
      return(false);
   if(!Add(m_edit_stoploss))
      return(false);




   x1 = (MARGEM_ESQUERDA * 3);
   y1 = (MARGEM_TOPO * 10);
   x2 = x1 + 90;
   y2 = y1 + ALTURA;
   if(!m_title_takeprofit.Create(m_chart_id,m_name+"m_title_takeprofit",m_subwin,x1,y1,x2,y2))
      return(false);
   m_title_takeprofit.FontSize(FONT_NAME);
   m_title_takeprofit.Color(colorTitle);

   if(!m_title_takeprofit.Text("TakeProfit"))
      return(false);
   if(!Add(m_title_takeprofit))
      return(false);





   x1 = (MARGEM_ESQUERDA * 25);
   y1 = (MARGEM_TOPO * 10);
   x2 = x1 + 100;
   y2 = y1 + ALTURA;
   if(!m_edit_takeprofit.Create(m_chart_id,m_name+"m_edit_takeprofit",m_subwin,x1,y1,x2,y2))
      return(false);
   m_edit_takeprofit.FontSize(FONT_NAME);
   m_edit_takeprofit.Color(clrBlack);
   m_edit_takeprofit.TextAlign(ALIGN_CENTER);
   if(!m_edit_takeprofit.Text("300"))
      return(false);
   if(!Add(m_edit_takeprofit))
      return(false);



///////////////////////////////////////////////////




   x1 = (MARGEM_ESQUERDA * 6);
   y1 = (MARGEM_TOPO * 14);
   x2 = x1 + 10;
   y2 = y1 + 10;
   if(!m_squere_status.Create(m_chart_id,m_name+"m_squere_status",m_subwin,x1,y1,x2,y2))
      return(false);

   m_squere_status.Color(colorSquereOff);

   m_squere_status.ColorBackground(colorSquereOff);
   m_squere_status.ColorBorder(colorSquereOff);
   m_squere_status.FontSize(30);

   if(!Add(m_squere_status))
      return(false);






   x1 = (MARGEM_ESQUERDA * 25);
   y1 = (MARGEM_TOPO * 13.5);
   x2 = x1 + 95;
   y2 = y1 + ALTURA;
   if(!m_title_on_operation.Create(m_chart_id,m_name+"m_title_on_operation",m_subwin,x1,y1,x2,y2))
      return(false);
   m_title_on_operation.FontSize(FONT_NAME);
   m_title_on_operation.Color(colorTitle);

   if(!m_title_on_operation.Text("Em operação"))
      return(false);
   if(!Add(m_title_on_operation))
      return(false);





   x1 = (MARGEM_ESQUERDA * 3);
   y1 = (MARGEM_TOPO * 16);
   x2 = x1 + 90;
   y2 = y1 + ALTURA;
   if(!m_title_eto.Create(m_chart_id,m_name+"m_title_eto",m_subwin,x1,y1,x2,y2))
      return(false);
   m_title_eto.FontSize(FONT_NAME);
   m_title_eto.Color(colorTitle);

   if(!m_title_eto.Text("E.T.O"))
      return(false);
   if(!Add(m_title_eto))
      return(false);




   x1 = (MARGEM_ESQUERDA * 20);
   y1 = (MARGEM_TOPO * 16);
   x2 = x1 + 130;
   y2 = y1 + ALTURA;
   if(!m_button_eto.Create(m_chart_id,m_name+"m_button_eto",m_subwin,x1,y1,x2,y2))
      return(false);
   m_button_eto.FontSize(FONT_NAME);
   m_button_eto.Color(clrWhite);
   m_button_eto.ColorBackground(colorProfitOff);
   m_button_eto.ColorBorder(colorProfitOff);

   if(!m_button_eto.Text("$0.0"))
      return(false);
   if(!Add(m_button_eto))
      return(false);




   x1 = (MARGEM_ESQUERDA * 3);
   y1 = (MARGEM_TOPO * 18.5);
   x2 = x1 + 215;
   y2 = y1 + ALTURA;
   if(!m_info_position_current.Create(m_chart_id,m_name+"m_info_position_current",m_subwin,x1,y1,x2,y2))
      return(false);
   m_info_position_current.FontSize(FONT_NAME);
   m_info_position_current.Color(colorTitle);

   if(!m_info_position_current.Text("No hay orden abierta"))
      return(false);
   if(!Add(m_info_position_current))
      return(false);





   x1 = (MARGEM_ESQUERDA * 9);
   y1 = (MARGEM_TOPO * 21.5);
   x2 = x1 + 150;
   y2 = y1 + 3;
   if(!m_divisor_horizontal_1.Create(m_chart_id,m_name+"m_divisor_horizontal_1",m_subwin,x1,y1,x2,y2))
      return(false);

   m_divisor_horizontal_1.Color(colorTitle);

   m_divisor_horizontal_1.ColorBackground(colorDivisorBG);
   m_divisor_horizontal_1.ColorBorder(colorDivisorBorder);
   m_divisor_horizontal_1.FontSize(30);

   if(!Add(m_divisor_horizontal_1))
      return(false);

//////////////////////////////////////////////////////////////






   x1 = (MARGEM_ESQUERDA * 3);
   y1 = (MARGEM_TOPO * 23);
   x2 = x1 + 80;
   y2 = y1 + ALTURA;
   if(!m_btn_add_alert.Create(m_chart_id,m_name+"m_btn_add_alert",m_subwin,x1,y1,x2,y2))
      return(false);
   m_btn_add_alert.FontSize(FONT_NAME);
   m_btn_add_alert.Color(clrBlack);

   if(!m_btn_add_alert.Text("+ Alerta"))
      return(false);
   if(!Add(m_btn_add_alert))
      return(false);





   x1 = (MARGEM_ESQUERDA * 25);
   y1 = (MARGEM_TOPO * 23);
   x2 = x1 + 100;
   y2 = y1 + ALTURA;
   if(!m_cbx_position_alert.Create(m_chart_id,m_name+"m_cbx_position_alert",m_subwin,x1,y1,x2,y2))
      return(false);
   m_cbx_position_alert.AddItem("Ulti. Topo",0);
   m_cbx_position_alert.AddItem("Ulti. Fundo",1);
   m_cbx_position_alert.Select(0);
   if(!Add(m_cbx_position_alert))
      return(false);




   x1 = (MARGEM_ESQUERDA * 9);
   y1 = (MARGEM_TOPO * 26);
   x2 = x1 + 150;
   y2 = y1 + 3;
   if(!m_divisor_horizontal_2.Create(m_chart_id,m_name+"m_divisor_horizontal_2",m_subwin,x1,y1,x2,y2))
      return(false);

   m_divisor_horizontal_2.Color(colorTitle);

   m_divisor_horizontal_2.ColorBackground(colorDivisorBG);
   m_divisor_horizontal_2.ColorBorder(colorDivisorBorder);
   m_divisor_horizontal_2.FontSize(30);

   if(!Add(m_divisor_horizontal_2))
      return(false);


   /*
      x1 = (MARGEM_ESQUERDA * 9);
      y1 = (MARGEM_TOPO * 29);
      x2 = x1 + 40;
      y2 = y1 + ALTURA * 2;

   */
   x1 = (MARGEM_ESQUERDA * 4);
   y1 = (MARGEM_TOPO * 27);
   x2 = x1 + 80;
   y2 = y1 + ALTURA * 1.5;
   if(!m_btn_buy.Create(m_chart_id,m_name+"m_btn_buy",m_subwin,x1,y1,x2,y2))
      return(false);
   m_btn_buy.FontSize(FONT_NAME);

   m_btn_buy.Color(colorTextBuy);
   m_btn_buy.ColorBackground(colorBackgroundBuy);
   m_btn_buy.ColorBorder(colorBorderBuy);

   if(!m_btn_buy.Text("BUY"))
      return(false);
   if(!Add(m_btn_buy))
      return(false);




   x1 = (MARGEM_ESQUERDA * 4);
   y1 = (MARGEM_TOPO * 30.5);
   x2 = x1 + 80;
   y2 = y1 + ALTURA * 1.5;
   if(!m_btn_pedding_buy.Create(m_chart_id,m_name+"m_btn_pedding_buy",m_subwin,x1,y1,x2,y2))
      return(false);
   m_btn_pedding_buy.FontSize(FONT_NAME);

   m_btn_pedding_buy.Color(colorTextBuyPeddin);
   m_btn_pedding_buy.ColorBackground(colorBackgroundBuyPeddin);
   m_btn_pedding_buy.ColorBorder(colorBorderBuyPeddin);

   if(!m_btn_pedding_buy.Text("BUY PD"))
      return(false);
   if(!Add(m_btn_pedding_buy))
      return(false);








   /*
      x1 = (MARGEM_ESQUERDA * 33);
      y1 = (MARGEM_TOPO * 29);
      x2 = x1 + 40;
      y2 = y1 + ALTURA * 2;

   */
   x1 = (MARGEM_ESQUERDA * 28);
   y1 = (MARGEM_TOPO * 27);
   x2 = x1 + 80;
   y2 = y1 + ALTURA * 1.5;
   if(!m_btn_sell.Create(m_chart_id,m_name+"m_btn_sell",m_subwin,x1,y1,x2,y2))
      return(false);
   m_btn_sell.FontSize(FONT_NAME);

   m_btn_sell.Color(colorTextSell);
   m_btn_sell.ColorBackground(colorBackgroundSell);
   m_btn_sell.ColorBorder(colorBorderSell);

   if(!m_btn_sell.Text("SELL"))
      return(false);
   if(!Add(m_btn_sell))
      return(false);



   x1 = (MARGEM_ESQUERDA * 28);
   y1 = (MARGEM_TOPO * 30.5);
   x2 = x1 + 80;
   y2 = y1 + ALTURA * 1.5;
   if(!m_btn_pedding_sell.Create(m_chart_id,m_name+"m_btn_pedding_sell",m_subwin,x1,y1,x2,y2))
      return(false);
   m_btn_pedding_sell.FontSize(FONT_NAME);

   m_btn_pedding_sell.Color(colorTextSellPeddin);
   m_btn_pedding_sell.ColorBackground(colorBackgroundSellPeddin);
   m_btn_pedding_sell.ColorBorder(colorBorderSellPeddin);

   if(!m_btn_pedding_sell.Text("SELL PD"))
      return(false);
   if(!Add(m_btn_pedding_sell))
      return(false);




   return true;

  }



//+------------------------------------------------------------------+
//|                                                                  |
//| Methot that converting number to PIPs, TICKs and PONTOS          |
//|                                                                  |
//+------------------------------------------------------------------+
double CMyWndClient::return_value_converting(double valueInput)
  {
   if(m_cbx_converting.Value() == 0)  // pips
      return ((valueInput*100)*_Point);

   if(m_cbx_converting.Value() == 1)  // ticks
      return ((valueInput*10)*_Point);

   if(m_cbx_converting.Value() == 2)  // pontos
      return (valueInput*_Point);
   return 0.0;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyWndClient::set_name_version(string name)
  {

   m_title_main.Text(name);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMyWndClient::get_lot()
  {
   return (double)m_edit_lot.Text();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyWndClient::set_lot(string value)
  {
   m_edit_lot.Text(value);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CMyWndClient::get_converting()
  {
   return m_cbx_converting.Value();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyWndClient::set_converting(int value)
  {
   m_cbx_converting.Select(value);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMyWndClient::get_value_stoploss(bool pure)
  {
   if(pure == true)
      return (double)m_edit_stoploss.Text();
   else
      return return_value_converting((double)m_edit_stoploss.Text());
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyWndClient::set_value_stoploss(string value)
  {
   m_edit_stoploss.Text(value);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMyWndClient::get_value_takeprofit(bool pure)
  {
   if(pure == true)
      return (double)m_edit_takeprofit.Text();
   else
      return return_value_converting((double)m_edit_takeprofit.Text());
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyWndClient::set_value_takeprofit(string value)
  {
   m_edit_takeprofit.Text(value);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyWndClient::set_status_position(int status)
  {

   if(status == 1)
     {
      m_squere_status.Color(colorSquereOn);
      m_squere_status.ColorBackground(colorSquereOn);
      m_squere_status.ColorBorder(colorSquereOn);
     }
   if(status == 2)
     {
      m_squere_status.Color(colorSquereOff);
      m_squere_status.ColorBackground(colorSquereOff);
      m_squere_status.ColorBorder(colorSquereOff);
     }

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyWndClient::set_text_status_position(string textStatus)
  {
   m_info_position_current.Text(textStatus);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMyWndClient::set_eto_profit(double profit)
  {
   m_button_eto.Text("$ "+profit);

   /*

   color colorProfitPositive = C'54,98,201';
   color colorProfitNegative = C'255,85,85';

   */


   if(profit > 0)
     {
      m_button_eto.Color(clrWhite);
      m_button_eto.ColorBackground(colorProfitPositive);
      m_button_eto.ColorBorder(colorProfitPositive);

     }
   if(profit < 0)
     {
      m_button_eto.Color(clrWhite);

      m_button_eto.ColorBackground(colorProfitNegative);
      m_button_eto.ColorBorder(colorProfitNegative);

     }
   if(profit == 0)
     {
      m_button_eto.Color(clrWhite);
      m_button_eto.ColorBackground(colorProfitOff);
      m_button_eto.ColorBorder(colorProfitOff);
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CMyWndClient::get_direction_alert()
  {
   return m_cbx_position_alert.Value();
  }



#include <Trade/Trade.mqh>
CTrade trade;



input group                         "Login"
input string                        CHANNEL_EMAIL_PROTOCOL                              = "renan234@msn.com";    // Email
input string                        CHANNEL_NAME_PROTOCOL                              = "CANAL_OURO";    // Nome do canal

input group                         "Configuração"

input int                           MAGIC_NUM                               = 3333333;          // Número Mágico
input group                         "Notificação"
color                         COLOR_TRIGGER                           = clrBlue;          // activar
color                         COLOR_TRIGGERED                         = clrRed;           // Acionado
input bool                          USING_ALERT                             = true;             // Alerta
input bool                          USING_NOTIFICATION                       = true;            // Push Notificação
input bool                          USING_SOUNG                             = true;             // Aviso sonoro


int static LIMIT_ALERT = 150;

string NAME_ROOT_JSON = NAME_BOT+"_";

const string URL_SERVER = "http://192.168.1.6:8080";
//const string URL_SERVER = "http://load-balance-1691754745.sa-east-1.elb.amazonaws.com";

int KEY_FLOW_GLOBAL = LOCK;


string GLOBAL_KEY_HEADER = "";
int GLOBAL_AGENT_ID = -1;
int GLOBAL_CHANNEL_ID = -1;
int GLOBAL_QTT_ALERT = -1;
int GLOBAL_QTT_COPY_ALERT = -1;

static int GLOBAL_LIMIT_LOOP = 10;





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void get_webrequest(string url, bool headersUsing,int &retCode, string &requestJson)
  {
   string jsonData = "";
   int jsonDataSize = 0;
   uchar jsonDataChar[];
   StringToCharArray(jsonData, jsonDataChar, 0,jsonDataSize,CP_UTF8);

   string headers = "";
   if(headersUsing == YES)
      headers = "Authorization:"+GLOBAL_KEY_HEADER;
   else
      headers = "";

   uchar serverResult[];
   string serverHeaders;
   retCode = WebRequest("GET", url,headers,500,jsonDataChar,  serverResult, serverHeaders);
   if(retCode == 200 || retCode == 201)
      requestJson = CharArrayToString(serverResult,0,ArraySize(serverResult), CP_UTF8);
   else
      if(retCode == 1001)
        {
         requestJson = ("Servidor não encontrado");
        }
      else
         requestJson = CharArrayToString(serverResult,0,ArraySize(serverResult), CP_UTF8);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int autentication_server()
  {

   string msgError = "";
   int loopAuth = 0;
   do
     {
      int retCode = 0;
      string jsonToken = "";
      string urlToken = URL_SERVER+"/Agent/Auth/?login="+CHANNEL_EMAIL_PROTOCOL;
      get_webrequest(urlToken,NO,retCode,jsonToken);
      msgError = "";
      if(retCode == 200 || retCode == 201)
        {
         msgError = "";
         Print("Token gerado com sucesso !");
         CJAVal json;
         json.Deserialize(jsonToken);
         GLOBAL_KEY_HEADER = json["token"].ToStr();
         loopAuth = GLOBAL_LIMIT_LOOP + 2;
         Print("id agent :  "+json["id"].ToInt());
         break;
        }
      else
        {
         if(retCode == 1001)
            msgError += ("Servidor fora do ar .");
         else
           {
            CJAVal json;
            json.Deserialize(jsonToken);
            msgError += json["message_error"].ToStr();
            Print("  -     "+retCode);
            Print("erro na solicitação    "+msgError);
           }
         loopAuth++;
         Print("\nTentativa de conecção :   "+loopAuth+" / "+GLOBAL_LIMIT_LOOP);
         Sleep(700);
        }
     }
   while(loopAuth <= GLOBAL_LIMIT_LOOP);

   if(msgError != "")
     {
      Print(msgError);
      Alert(msgError);
     }

   if(GLOBAL_KEY_HEADER != "")
     {
      Print(GLOBAL_KEY_HEADER);

      msgError = "";
      loopAuth = 0;
      do
        {
         int retCode = 0;
         string jsonRequest= "";
         string urlToken = URL_SERVER+"/Agent/Login/mt5/?login="+CHANNEL_EMAIL_PROTOCOL+ "&channel="+CHANNEL_NAME_PROTOCOL;
         get_webrequest(urlToken,YES,retCode,jsonRequest);

         msgError = "";
         if(retCode == 200 || retCode == 201)
           {
            Print("Login realizado com sucesso !");
            msgError = "";

            CJAVal json;
            json.Deserialize(jsonRequest);
            GLOBAL_AGENT_ID = json["agent_id"].ToInt();
            GLOBAL_CHANNEL_ID = json["channel_id"].ToInt();
            GLOBAL_QTT_ALERT = json["quantity_alerts"].ToInt();
            GLOBAL_QTT_COPY_ALERT = json["quantity_account_copy"].ToInt();

            Print("GLOBAL_CHANNEL_ID  "+GLOBAL_CHANNEL_ID);
            Print("GLOBAL_AGENT_ID  "+GLOBAL_AGENT_ID);
            Print("GLOBAL_QTT_ALERT  "+GLOBAL_QTT_ALERT);
            Print("GLOBAL_QTT_COPY_ALERT  "+GLOBAL_QTT_COPY_ALERT);

            loopAuth = GLOBAL_LIMIT_LOOP + 2;
            break;
           }
         else
           {
            if(retCode == 1001)
               msgError += ("Servidor fora do ar .");
            else
              {
               CJAVal json;
               json.Deserialize(jsonRequest);
               msgError += json["message_error"].ToStr();
               Print("  -     "+retCode);
               Print("erro na solicitação    "+msgError);
              }
            loopAuth++;
            Print("\nTentativa de conecção :   "+loopAuth+" / "+GLOBAL_LIMIT_LOOP);
            Sleep(700);
           }

        }
      while(loopAuth <= GLOBAL_LIMIT_LOOP);
     }

   if(msgError != "")
     {
      Print(msgError);
      Alert(msgError);
     }


   if(GLOBAL_KEY_HEADER == "" || GLOBAL_AGENT_ID == -1  || GLOBAL_CHANNEL_ID == -1)
      return INIT_FAILED;
   else
     {
      KEY_FLOW_GLOBAL = UNLOCK;

      return INIT_SUCCEEDED;
     }
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void post_send_copy(string symbol,
                    string actionType,
                    ulong ticket,
                    double lot,
                    double targetPedding,
                    double takeprofit,
                    double stoploss)

  {

   Print("Se preparando para enviar uma copy... [ AGUARDE ] ");
   string jsonData = create_json_send_order(symbol,
                     actionType,
                     ticket,
                     lot,
                     targetPedding,
                     takeprofit,
                     stoploss);


   string msgError = "";

   int loopAuth = 0;
   do
     {
      int retCode = 0;
      string jsonToken = "";
      string urlToken = URL_SERVER+"/Copy/Send";
      post_webrequest(urlToken,jsonData,retCode,jsonToken);
      string msgError = "";

      if(retCode == 200 || retCode == 201)
        {
         msgError = "";
         Print("Copy enviada com sucesso !");
         loopAuth = GLOBAL_LIMIT_LOOP + 2;
         break;
        }
      else
        {
         if(retCode == 1001)
            msgError += ("Servidor fora do ar .");
         else
           {
            CJAVal json;
            json.Deserialize(jsonToken);
            msgError += json["message_error"].ToStr();
            Print("  -     "+retCode);
            Print("erro na solicitação    "+msgError);
           }
         loopAuth++;
         Print("\nTentativa de conecção :   "+loopAuth+" / "+GLOBAL_LIMIT_LOOP);
         Sleep(700);
        }
     }
   while(loopAuth <= GLOBAL_LIMIT_LOOP);

   if(msgError != "")
     {
      Print(msgError);
      Alert(msgError);
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void post_webrequest(string url, string jsonData, int &retCode, string &requestJson)
  {
   int jsonDataSize = StringLen(jsonData);
   uchar jsonDataChar[];
   StringToCharArray(jsonData, jsonDataChar, 0,jsonDataSize,CP_UTF8);

   string headers = "Authorization:"+GLOBAL_KEY_HEADER;

   uchar serverResult[];
   string serverHeaders;
   retCode = WebRequest("POST", url,headers,500,jsonDataChar,  serverResult, serverHeaders);
   if(retCode == 200 || retCode == 201)
      requestJson = CharArrayToString(serverResult,0,ArraySize(serverResult), CP_UTF8);
   else
      if(retCode == 1001)
        {
         requestJson = ("Servidor não encontrado");
        }
      else
         requestJson = CharArrayToString(serverResult,0,ArraySize(serverResult), CP_UTF8);
  }


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   GLOBAL_AGENT_ID = -1;
   GLOBAL_KEY_HEADER = "";
   KEY_FLOW_GLOBAL = LOCK;

   if(autentication_server() != INIT_SUCCEEDED)
      return INIT_FAILED;

   GLOBAL_CHARTEVENT_CLICK_PEDDING = "";
   ArrayFree(GLOBAL_SAVE_LIMIT_ORDER);
   ArrayFree(GLOBAL_SAVE_TP_AND_SL);

   timerWaitClick = TimeCurrent();
   trade.SetExpertMagicNumber(MAGIC_NUM);
   onInit_panel_datas();
   onInit_backup_datas();
   EventSetTimer(1);

   return(INIT_SUCCEEDED);
  }



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   onDeinit_backup_datas();
   onDeinit_panel_datas(reason);
   EventKillTimer();

   Comment("");
  }


int lockedDemo = UNLOCK;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {



   if(demo_module() != "")
     {
      //      if(lockedDemo == UNLOCK)
      //        {
      //         Alert(demo_module());
      //         Comment(demo_module());
      //         Print(demo_module());
      //         lockedDemo  = LOCK;
      //        }
      return;
     }




   monitoring_buttons_on_chart();

   monitoring_orders_limit();

   monitoring_tp_and_sl();

   Struct_color_lines array_color_line[];
   int totalObj = fill_array_color_line_horizontal(array_color_line);



   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   CopyRates(Symbol(), Period(),0,3,rates);

   double priceClose = rates[0].close;

// moniturar quando o preço em run timer romper
   for(int i = 0; i < totalObj; i++)
     {
      double priceLine = array_color_line[i].price;
      color corLineH = array_color_line[i].colorLine;
      string name = array_color_line[i].name;

      if(StringFind(name,"ALERTA_FUNDO_"+MAGIC_NUM+"_",0) >= 0)
        {
         if(priceClose < priceLine)
           {
            // alertar e mudar a cor
            ObjectSetInteger(ChartID(),name,OBJPROP_COLOR,COLOR_TRIGGERED);
            string text = "Alerta\nse ha alcanzado el precio "+adjust_price(priceLine);
            send_notification(text);
            break;
           }
        }

      if(StringFind(name,"ALERTA_TOPO_"+MAGIC_NUM+"_",0) >= 0)
        {
         if(priceClose > priceLine)
           {
            Print("TO EM CIMA");
            // alertar e mudar a cor
            ObjectSetInteger(ChartID(),name,OBJPROP_COLOR,COLOR_TRIGGERED);
            string text = "Alerta\nse ha alcanzado el precio "+adjust_price(priceLine);
            send_notification(text);
            break;
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {





   ClientArea.set_name_version(NAME_BOT+" v"+VERSION);
   if(is_position() == YES)
     {

      ClientArea.set_eto_profit(NormalizeDouble(get_profit_runtimer(),2));
      int countPos = get_count_positions_opened();
      ClientArea.set_text_status_position("Hay "+countPos+" pedidos abiertos");
      ClientArea.set_status_position(1);
     }
   else
     {
      ClientArea.set_eto_profit("-----");
      ClientArea.set_text_status_position("Não tem ordens abertas");
      ClientArea.set_status_position(2);
     }

//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
   project_button_market_close();

   project_button_padding_close();



  }



datetime timerWaitClick = 0;
string valueTempX = "";
string valueTempY = "";
string GLOBAL_CHARTEVENT_CLICK_PEDDING = "";
//+------------------------------------------------------------------+
//| Expert chart event function                                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // event ID
                  const long& lparam,   // event parameter of the long type
                  const double& dparam, // event parameter of the double type
                  const string& sparam)   // event parameter of the string type
  {
   onChartEvent_panel_datas(id,lparam,dparam,sparam);

   if(demo_module() == "")
      if(TimeCurrent() > timerWaitClick)
         if(id == CHARTEVENT_CLICK)
           {

            if(GLOBAL_CHARTEVENT_CLICK_PEDDING != ""  && (valueTempX != lparam && valueTempY != dparam))
              {
               datetime timeCurrent;
               double priceLimit ;
               int subWindowsLimit;
               ChartXYToTimePrice(ChartID(),lparam,dparam,subWindowsLimit,timeCurrent,priceLimit);
               timeCurrent = TimeCurrent();
               if(GLOBAL_CHARTEVENT_CLICK_PEDDING == "BUY_PEDDING")
                 {
                  double tp = 0;
                  if(ClientArea.get_value_takeprofit(false) != 0)
                     tp = priceLimit + ClientArea.get_value_takeprofit(false);

                  double sl = 0;
                  if(ClientArea.get_value_stoploss(false) != 0)
                     sl = priceLimit - ClientArea.get_value_stoploss(false);

                  double lot = ClientArea.get_lot();
                  pedding_buy(priceLimit,lot,tp,sl);
                 }

               if(GLOBAL_CHARTEVENT_CLICK_PEDDING == "SELL_PEDDING")
                 {
                  double tp = 0;
                  if(ClientArea.get_value_takeprofit(false) != 0)
                     tp = priceLimit - ClientArea.get_value_takeprofit(false);

                  double sl = 0;
                  if(ClientArea.get_value_stoploss(false) != 0)
                     sl = priceLimit + ClientArea.get_value_stoploss(false);
                  double lot = ClientArea.get_lot();
                  pedding_sell(priceLimit,lot,tp,sl);
                 }
               timerWaitClick = TimeCurrent() + 2;
               GLOBAL_CHARTEVENT_CLICK_PEDDING = "";

               // voltar o estilo do ponteiro do mouse
              }
           }

   if(demo_module() == "")
      if(TimeCurrent() > timerWaitClick)
         if(id == CHARTEVENT_OBJECT_CLICK)
           {
            if(StringFind(sparam,"m_button_eto",0) >= 0)
              {
               timerWaitClick = TimeCurrent() + 2;
               send_datas_for_clients(0,0,0,0,0,"DELETAR_TUDO");
               delete_all_orders_opened();
              }


            if(StringFind(sparam,"m_btn_add_alert",0) >= 0)
              {
               timerWaitClick = TimeCurrent() + 2;
               Struct_color_lines array_color_line[];
               int totalObj = fill_array_color_line_horizontal(array_color_line);
               if(totalObj >= LIMIT_ALERT)
                  Alert("VOCÊ SÓ PODE INSERIR "+LIMIT_ALERT+" ALERTAS !");
               else
                  add_alert_from_button();

              }

            if(StringFind(sparam,"m_btn_pedding_buy",0) >= 0)
              {
               valueTempX = lparam;
               valueTempY = dparam;
               GLOBAL_CHARTEVENT_CLICK_PEDDING = "BUY_PEDDING";
               // mudar o estilo do ponteiro do mouse
              }


            if(StringFind(sparam,"m_btn_pedding_sell",0) >= 0)
              {
               valueTempX = lparam;
               valueTempY = dparam;
               GLOBAL_CHARTEVENT_CLICK_PEDDING = "SELL_PEDDING";
               // mudar o estilo do ponteiro do mouse
              }


            if(StringFind(sparam,"m_btn_buy",0) >= 0)
              {
               timerWaitClick = TimeCurrent() + 2;
               double ask = SymbolInfoDouble(_Symbol,   SYMBOL_ASK);

               double tp = 0;
               if(ClientArea.get_value_takeprofit(false) != 0)
                  tp = ask + ClientArea.get_value_takeprofit(false);

               double sl = 0;
               if(ClientArea.get_value_stoploss(false) != 0)
                  sl = ask - ClientArea.get_value_stoploss(false);
               double lot = ClientArea.get_lot();
               buy_market(tp,sl,lot,"");

              }

            if(StringFind(sparam,"m_btn_sell",0) >= 0)
              {
               timerWaitClick = TimeCurrent() + 2;
               double bid = SymbolInfoDouble(_Symbol,   SYMBOL_BID);

               double tp = 0;
               if(ClientArea.get_value_takeprofit(false) != 0)
                  tp = bid - ClientArea.get_value_takeprofit(false);

               double sl = 0;
               if(ClientArea.get_value_stoploss(false) != 0)
                  sl = bid + ClientArea.get_value_stoploss(false);
               double lot = ClientArea.get_lot();
               sell_market(tp,sl,lot,"");

              }

            if(StringFind(sparam,"BTN_CLOSE_",0) >= 0)
              {
               timerWaitClick = TimeCurrent() + 2;
               int posStart = 0;
               int posEnd = 0;
               find_text(sparam,"BTN_CLOSE_#",posStart,posEnd);
               ulong ticket = (ulong)StringSubstr(sparam,posEnd,StringLen(sparam)-1);


               trade.PositionClose(ticket);
               ObjectDelete(ChartID(),sparam);
               send_datas_for_clients(ticket,0,0,0,0,"DELETAR");
              }


            if(StringFind(sparam,"BTN_PEDDING_CLOSE_",0) >= 0)
              {
               timerWaitClick = TimeCurrent() + 2;
               int posStart = 0;
               int posEnd = 0;
               find_text(sparam,"BTN_PEDDING_CLOSE_#",posStart,posEnd);
               ulong ticket = (ulong)StringSubstr(sparam,posEnd,StringLen(sparam)-1);

               ObjectDelete(ChartID(),sparam);
               send_datas_for_clients(ticket,0,0,0,0,"DEL_PEDDING");
               trade.OrderDelete(ticket);
              }
           }
  }







//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string create_json_send_order(string symbol,
                              string actionType,
                              ulong ticket,
                              double lot,
                              double targetPedding,
                              double takeprofit,
                              double stoploss)
  {

   string itemJson = "";
   itemJson += "{";
   itemJson += "\"symbol\":\""+symbol+"\",";
   itemJson += "\"action_type\":\""+actionType+"\",";
   itemJson += "\"ticket\":"+ticket+",";
   itemJson += "\"lot\":"+lot+",";
   itemJson += "\"target_pedding\":"+targetPedding+",";
   itemJson += "\"takeprofit\":"+takeprofit+",";
   itemJson += "\"stoploss\":"+stoploss+",";

   string dtSendOrder = (TimeToString(TimeCurrent(),TIME_DATE  | TIME_MINUTES | TIME_SECONDS));
   StringReplace(dtSendOrder,".","-");

   itemJson += "\"dt_send_order\":\""+dtSendOrder+"\",";

   itemJson += "\"user_agent_id\":"+GLOBAL_AGENT_ID+" ,";
   itemJson += "\"channel_id\":"+GLOBAL_CHANNEL_ID+"";


   itemJson += "}";
   Print("\n\n\n"+itemJson );
   
   return itemJson;
  }







//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void send_datas_for_clients(ulong tkt,double lot,double targetPedding, double takprofit,double stoploss,string actionType)
  {

   /*
         <<    ACTION_KEY
            |
               SYMBOLO
            |
               TIPO ACAO
            |
               TKT
            |
               LOTE
            |
               TP
            |
               SL
         >>


      TIPO DE ACAO
         BUY
         SELL

         BUY_LIMIT
         BUY_STOP
         SELL_LIMIT
         SELL_STOP

         DELETAR

         DELETAR_TUDO

         EDITAR



   */

   post_send_copy(_Symbol,actionType,tkt,lot,targetPedding,takprofit,stoploss);




  }




struct Struct_color_lines
  {
   string            name;
   color             colorLine;
   double            price;
  };


struct Struct_tP_and_sl
  {
   ulong             tkt;
   double            stopLoss;
   double            takeProfit;
  };


Struct_tP_and_sl GLOBAL_SAVE_TP_AND_SL[];
Struct_tP_and_sl GLOBAL_SAVE_LIMIT_ORDER[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void monitoring_tp_and_sl()
  {
   int total=PositionsTotal();

   if(total == 0)
      return ;

   for(int cnt=0; cnt<total; cnt++)
     {
      string symbol = PositionGetSymbol(cnt);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if((_Symbol == symbol  && magic == MAGIC_NUM)|| (_Symbol == symbol  || magic == MAGIC_NUM))
        {
         ulong ticket = PositionGetInteger(POSITION_TICKET);
         double stopLoss = adjust_price(PositionGetDouble(POSITION_SL));
         double takeProfit = adjust_price(PositionGetDouble(POSITION_TP));
         add_on_list_tp_and_sl_global(GLOBAL_SAVE_TP_AND_SL,ticket,takeProfit,stopLoss,"EDITAR");
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void add_on_list_tp_and_sl_global(Struct_tP_and_sl &G_SAVE_TP_AND_SL[],ulong ticket,double takeProfit,double stopLoss,string KEY)
  {


// ver se ja existe o tkt add na lista
   if(ArraySize(G_SAVE_TP_AND_SL) > 0)
     {
      bool tktExist = NO;
      for(int i = 0 ; i < ArraySize(G_SAVE_TP_AND_SL); i++)
        {
         if(G_SAVE_TP_AND_SL[i].tkt == ticket)
           {
            tktExist = YES;
            if(G_SAVE_TP_AND_SL[i].stopLoss != stopLoss ||
               G_SAVE_TP_AND_SL[i].takeProfit != takeProfit)
              {

               G_SAVE_TP_AND_SL[i].tkt = ticket;
               G_SAVE_TP_AND_SL[i].stopLoss = stopLoss;
               G_SAVE_TP_AND_SL[i].takeProfit = takeProfit;

               send_datas_for_clients(ticket,0,0,takeProfit,stopLoss,KEY);
               break;
              }
           }
        }
      if(tktExist == NO)
        {
         // se entrar aqui.. significa que existe coisas na lista, porem ela ainda não esta na lista
         ArrayResize(G_SAVE_TP_AND_SL,ArraySize(G_SAVE_TP_AND_SL)+1);
         G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].tkt = ticket;
         G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].stopLoss = stopLoss;
         G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].takeProfit = takeProfit;
         return;
        }

     }
   else
     {
      // se nao  existe nada... add o primeiro

      ArrayResize(G_SAVE_TP_AND_SL,ArraySize(G_SAVE_TP_AND_SL)+1);
      G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].tkt = ticket;
      G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].stopLoss = stopLoss;
      G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].takeProfit = takeProfit;
      return;
     }




  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void add_on_list_tp_and_sl_pedding(Struct_tP_and_sl &G_SAVE_TP_AND_SL[],ulong ticket,double lot, double priceTarget,double takeProfit,double stopLoss,string KEY)
  {


// ver se ja existe o tkt add na lista
   if(ArraySize(G_SAVE_TP_AND_SL) > 0)
     {
      bool tktExist = NO;
      for(int i = 0 ; i < ArraySize(G_SAVE_TP_AND_SL); i++)
        {
         if(G_SAVE_TP_AND_SL[i].tkt == ticket)
           {


            tktExist = YES;

            /*
                        if(KEY == "DEL_PEDDING" &&
                           G_SAVE_TP_AND_SL[i].tkt > 0)
                          {
                           COrderInfo myOrder;
                           if(myOrder.Select(GLOBAL_SAVE_LIMIT_ORDER[i].tkt) == NO)
                             {
                              G_SAVE_TP_AND_SL[i].tkt = -1;
                              send_datas_for_clients(ticket,lot,priceTarget,takeProfit,stopLoss,KEY);
                              break;
                             }
                          }
            */


            if(G_SAVE_TP_AND_SL[i].tkt > 0 && G_SAVE_TP_AND_SL[i].stopLoss != stopLoss ||
               G_SAVE_TP_AND_SL[i].takeProfit != takeProfit)
              {

               G_SAVE_TP_AND_SL[i].tkt = ticket;
               G_SAVE_TP_AND_SL[i].stopLoss = stopLoss;
               G_SAVE_TP_AND_SL[i].takeProfit = takeProfit;

               send_datas_for_clients(ticket,lot,priceTarget,takeProfit,stopLoss,KEY);
               break;
              }


           }
        }
      if(tktExist == NO)
        {
         // se entrar aqui.. significa que existe coisas na lista, porem ela ainda não esta na lista
         ArrayResize(G_SAVE_TP_AND_SL,ArraySize(G_SAVE_TP_AND_SL)+1);
         G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].tkt = ticket;
         G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].stopLoss = stopLoss;
         G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].takeProfit = takeProfit;
         return;
        }

     }
   else
     {
      // se nao  existe nada... add o primeiro

      ArrayResize(G_SAVE_TP_AND_SL,ArraySize(G_SAVE_TP_AND_SL)+1);
      G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].tkt = ticket;
      G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].stopLoss = stopLoss;
      G_SAVE_TP_AND_SL[ArraySize(G_SAVE_TP_AND_SL)-1].takeProfit = takeProfit;
      return;
     }




  }





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void monitoring_buttons_on_chart()
  {


   int total_objects = ObjectsTotal(ChartID(),0,OBJ_BUTTON);
   for(int i = 0; i < total_objects; i++)
     {
      string object_name = ObjectName(ChartID(),i,0,OBJ_BUTTON);
      if(StringFind(object_name,"BTN_CLOSE_",0) >= 0)
        {

         ulong tkt = get_tkt_button(object_name);
         CPositionInfo myPosition;
         if(myPosition.SelectByTicket(tkt) == NO)
            ObjectDelete(ChartID(),object_name);
        }
      if(StringFind(object_name,"BTN_PEDDING_CLOSE_",0) >= 0)
        {
         ulong tkt = get_tkt_button(object_name);
         COrderInfo myOrder;
         if(myOrder.Select(tkt) == NO)
            ObjectDelete(ChartID(),object_name);
        }
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong get_tkt_button(string obj_name)
  {

   string to_split= obj_name;
   string sep= "#";
   ushort u_sep;
   string result[];

   u_sep=StringGetCharacter(sep,0);

   int k=StringSplit(to_split,u_sep,result);
   return result[1];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void monitoring_orders_limit()
  {


   if(ArraySize(GLOBAL_SAVE_LIMIT_ORDER) > 0)
     {
      for(int i = 0; i < ArraySize(GLOBAL_SAVE_LIMIT_ORDER); i++)
        {
         COrderInfo myOrder;
         //         Print("myOrder.Select(GLOBAL_SAVE_LIMIT_ORDER[i].tkt)    "+myOrder.Select(GLOBAL_SAVE_LIMIT_ORDER[i].tkt));
         //         Print(""+ArraySize(GLOBAL_SAVE_LIMIT_ORDER) +"        |        tkt  "+GLOBAL_SAVE_LIMIT_ORDER[i].tkt);
         if(myOrder.Select(GLOBAL_SAVE_LIMIT_ORDER[i].tkt) == NO)
            add_on_list_tp_and_sl_pedding(GLOBAL_SAVE_LIMIT_ORDER,GLOBAL_SAVE_LIMIT_ORDER[i].tkt,0,0,0,0,"DEL_PEDDING");
        }
     }



//         ArrayResize(GLOBAL_SAVE_LIMIT_ORDER,ArraySize(GLOBAL_SAVE_LIMIT_ORDER)+1);
//         GLOBAL_SAVE_LIMIT_ORDER[ArraySize(GLOBAL_SAVE_LIMIT_ORDER)-1].tkt = ticket;
//         GLOBAL_SAVE_LIMIT_ORDER[ArraySize(GLOBAL_SAVE_LIMIT_ORDER)-1].stopLoss = stopLoss;
//         GLOBAL_SAVE_LIMIT_ORDER[ArraySize(GLOBAL_SAVE_LIMIT_ORDER)-1].takeProfit = takeProfit;



   uint total = OrdersTotal();
   if(total == 0)
      return;

   ulong ticket = 0;
   for(uint i=0; i<total; i++)
      if((ticket=OrderGetTicket(i))>0)
        {
         double symbol = OrderGetString(ORDER_SYMBOL);
         double order_magic = OrderGetInteger(ORDER_MAGIC);
         ulong ticket = OrderGetInteger(ORDER_TICKET);
         double takeProfit = adjust_price(OrderGetDouble(ORDER_TP));
         double stopLoss = adjust_price(OrderGetDouble(ORDER_SL));
         double priceTarget = adjust_price(OrderGetDouble(ORDER_PRICE_OPEN));
         // abastece o array global
         double lot = OrderGetDouble(ORDER_VOLUME_CURRENT);
         // verifica se ainda existe
         if(symbol == _Symbol || order_magic == MAGIC_NUM)
           {

            add_on_list_tp_and_sl_pedding(GLOBAL_SAVE_LIMIT_ORDER,ticket,lot,priceTarget,takeProfit,stopLoss,"MODIFICAR_PEDDING");
            //    trade.OrderDelete(ticket);
           }
        }


  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void pedding_buy(double targetBuy,double lot, double targetBuyTakeProfit,double targetBuyStopLoss)
  {
   double ask = SymbolInfoDouble(_Symbol,   SYMBOL_ASK);

   if(targetBuy < ask)
     {
      bool ok = trade.BuyLimit(lot,
                               adjust_price(targetBuy),
                               _Symbol,
                               adjust_price(targetBuyStopLoss),
                               adjust_price(targetBuyTakeProfit),
                               ORDER_TIME_GTC,0,"");
      if(!ok)
        {
         int errorCode = GetLastError();
         Print("lots    "+lot+"   BuyMarket : "+errorCode+"         |        ResultRetcode :  "+trade.ResultRetcode());
         ResetLastError();
         return;
        }

      Print("\n===== ORDEM PENDENTE DE BUY LIMIT| RESULT RET CODE :  "+trade.ResultRetcode());
      Print("LOTE ENVIADO  :  "+lot);
      ulong order = trade.ResultOrder();
      Print("TKT OFERTA : "+order);


      send_datas_for_clients(order,lot,targetBuy,targetBuyTakeProfit,targetBuyStopLoss,"BUY_LIMIT");
     }
   if(targetBuy > ask)
     {
      bool ok = trade.BuyStop(lot,
                              adjust_price(targetBuy),
                              _Symbol,
                              adjust_price(targetBuyStopLoss),
                              adjust_price(targetBuyTakeProfit),
                              ORDER_TIME_GTC,0,"");
      if(!ok)
        {
         int errorCode = GetLastError();
         Print("lots    "+lot+"   BuyMarket : "+errorCode+"         |        ResultRetcode :  "+trade.ResultRetcode());
         ResetLastError();
         return ;
        }

      Print("\n===== ORDEM PENDENTE DE BUY STOP| RESULT RET CODE :  "+trade.ResultRetcode());
      Print("LOTE ENVIADO  :  "+lot);
      ulong order = trade.ResultOrder();
      Print("TKT OFERTA : "+order);

      send_datas_for_clients(order,lot,targetBuy,targetBuyTakeProfit,targetBuyStopLoss,"BUY_STOP");

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void pedding_sell(double targetSell,double lot, double targetSellTakeProfit,double targetSellStopLoss)
  {
   double bid = SymbolInfoDouble(_Symbol,   SYMBOL_BID);
   if(targetSell > bid)
     {
      bool ok = trade.SellLimit(lot,
                                adjust_price(targetSell),
                                _Symbol,
                                adjust_price(targetSellStopLoss),
                                adjust_price(targetSellTakeProfit),
                                ORDER_TIME_GTC,0,"");
      if(!ok)
        {
         int errorCode = GetLastError();
         Print("lots    "+lot+"   BuyMarket : "+errorCode+"         |        ResultRetcode :  "+trade.ResultRetcode());
         ResetLastError();
         return ;
        }

      Print("\n===== ORDEM PENDENTE DE SELL LIMIT| RESULT RET CODE :  "+trade.ResultRetcode());
      Print("LOTE ENVIADO  :  "+lot);
      ulong order = trade.ResultOrder();
      Print("TKT OFERTA : "+order);


      send_datas_for_clients(order,lot,targetSell,targetSellTakeProfit,targetSellStopLoss,"SELL_LIMIT");
     }
   if(targetSell < bid)
     {
      bool ok = trade.SellStop(lot,
                               adjust_price(targetSell),
                               _Symbol,
                               adjust_price(targetSellStopLoss),
                               adjust_price(targetSellTakeProfit),
                               ORDER_TIME_GTC,0,"");
      if(!ok)
        {
         int errorCode = GetLastError();
         Print("lots    "+lot+"   BuyMarket : "+errorCode+"         |        ResultRetcode :  "+trade.ResultRetcode());
         ResetLastError();
         return ;
        }

      Print("\n===== ORDEM PENDENTE DE SELL STOP| RESULT RET CODE :  "+trade.ResultRetcode());
      Print("LOTE ENVIADO  :  "+lot);
      ulong order = trade.ResultOrder();
      Print("TKT OFERTA : "+order);

      send_datas_for_clients(order,lot,targetSell,targetSellTakeProfit,targetSellStopLoss,"SELL_STOP");
     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void find_text(string text, string phrase, int &posStart, int &posY)
  {
// encontra a posição da frase no texto
   int startPos = StringFind(text, phrase, 0);
   int endPos = startPos + StringLen(phrase) - 1;

// exibe a posição numérica e a posição de início e fim da frase
   if(startPos >= 0)
     {
      Print("Frase encontrada na posição numérica ", startPos, " (", startPos + 1, "-", endPos + 1, ")");
      posStart = startPos + 1;
      posY = endPos + 1;
     }
   else
     {
      Print("A frase não foi encontrada no texto.");
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void project_button_padding_close()
  {
   uint totalPedding = OrdersTotal();
   if(totalPedding == 0)
      return;

   ulong ticket = 0;
   for(uint i=0; i<totalPedding; i++)
      if((ticket=OrderGetTicket(i))>0)
        {
         double symbol = OrderGetString(ORDER_SYMBOL);
         double order_magic = OrderGetInteger(ORDER_MAGIC);
         ulong tktBase = OrderGetInteger(ORDER_TICKET);
         double takeProfit = adjust_price(OrderGetDouble(ORDER_TP));
         double stopLoss = adjust_price(OrderGetDouble(ORDER_SL));
         double priceTarget = adjust_price(OrderGetDouble(ORDER_PRICE_OPEN));
         // abastece o array global
         double lot = OrderGetDouble(ORDER_VOLUME_CURRENT);



         int coorX;
         int coorY;
         ChartTimePriceToXY(ChartID(),0,TimeCurrent(),priceTarget,coorX,coorY);


         ButtonCreate(ChartID(),"BTN_PEDDING_CLOSE_#"+tktBase,0,coorX,coorY,100,30,
                      CORNER_LEFT_UPPER,"[ x ]   PEDDING","Arial",10,clrBlack,clrWhite,clrWhite,false,false,false,false,0);
        }

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void project_button_market_close()
  {

   int total=PositionsTotal();

   if(total == 0)
      return;

   for(int cnt=0; cnt<total; cnt++)
     {
      string symbol = PositionGetSymbol(cnt);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if((_Symbol == symbol  && magic == MAGIC_NUM)|| (_Symbol == symbol  || magic == MAGIC_NUM))
        {
         double priceBase = PositionGetDouble(POSITION_PRICE_OPEN);

         int coorX;
         int coorY;
         ChartTimePriceToXY(ChartID(),0,TimeCurrent() + PeriodSeconds(PERIOD_CURRENT),priceBase,coorX,coorY);


         string tktBase = (string)PositionGetInteger(POSITION_TICKET);

         if(PositionGetDouble(POSITION_PROFIT)  == 0)
            ButtonCreate(ChartID(),"BTN_CLOSE_#"+tktBase,0,coorX,coorY,100,30,
                         CORNER_LEFT_UPPER,"[ x ]   $ "+DoubleToString(PositionGetDouble(POSITION_PROFIT),2),"Arial",10,clrBlack,clrWhite,clrWhite,true,false,false,false,0);


         if(PositionGetDouble(POSITION_PROFIT) > 0)
            ButtonCreate(ChartID(),"BTN_CLOSE_#"+tktBase,0,coorX,coorY,100,30,
                         CORNER_LEFT_UPPER,"[ x ]   $ "+DoubleToString(PositionGetDouble(POSITION_PROFIT),2),"Arial",10,clrBlack,C'155,155,255',C'155,155,255',true,false,false,false,0);


         if(PositionGetDouble(POSITION_PROFIT) < 0)
            ButtonCreate(ChartID(),"BTN_CLOSE_#"+tktBase,0,coorX,coorY,100,30,
                         CORNER_LEFT_UPPER,"[ x ]   $ "+DoubleToString(PositionGetDouble(POSITION_PROFIT),2),"Arial",10,clrBlack,C'255,168,168',C'255,168,168',true,false,false,false,0);

        }
     }


  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               x=0,                      // X coordinate
                  const int               y=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();

   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
//--- set button coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution




   return(true);
  }

































//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void onDeinit_backup_datas()
  {
   TRADE_INFO tradeInfo;
   tradeInfo.stoploss = ClientArea.get_value_stoploss(true);
   tradeInfo.takeprofit = ClientArea.get_value_takeprofit(true);
   tradeInfo.lot = ClientArea.get_lot();
   tradeInfo.typeConvert = ClientArea.get_converting();
   string  json = FormingJson(tradeInfo);
   SetBackUp(NAME_ROOT_JSON + "Backup", json);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void onInit_backup_datas()
  {
   TRADE_INFO tradeinfo[];
   string AUX[];
   string Json = GetBackUp(NAME_ROOT_JSON + "Backup");
   Print(Json);
   StringReplace(Json, "},{", "*");
   StringReplace(Json, "{", "");
   StringReplace(Json, "}", "");
   Fill(AUX, Json, "*");

   int siz = ArraySize(AUX);
   ArrayResize(tradeinfo, siz);
   Json.Upper();
   if(siz <= 0)
      return;

   string lot = Deserializer(AUX[0],"LOT",",");
   string takeprofit = Deserializer(AUX[0],"TP",",");
   string stoploss = Deserializer(AUX[0],"SL",",");
   int typeConvert = (int)Deserializer(AUX[0],"TP_CONVERT",",");

   if(typeConvert != -1 || lot == "0")
     {
      ClientArea.set_lot(lot);
      ClientArea.set_value_takeprofit(takeprofit);
      ClientArea.set_value_stoploss(stoploss);
      ClientArea.set_converting(typeConvert);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//| fix the number according to the decimal places of the asset      |
//|                                                                  |
//+------------------------------------------------------------------+
double adjust_price(double price)
  {
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   return(MathRound((price)/ tickSize) * tickSize);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void send_notification(string text)
  {

   if(USING_ALERT == true)
      Alert(text);
   if(USING_NOTIFICATION == true)
      SendNotification(text);

   if(USING_SOUNG == true)
      PlaySound("ok.wav");
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int  fill_array_color_line_horizontal(Struct_color_lines &array_color_line[])
  {
   int totalObj = 0;
   for(int i = 0; i < ObjectsTotal(ChartID(),0,OBJ_HLINE); i++)
     {

      color colorHorizontal = ObjectGetInteger(ChartID(),ObjectName(ChartID(),i,0,OBJ_HLINE),OBJPROP_COLOR);
      if(ObjectName(ChartID(),i,0,OBJ_HLINE) != "")
         if(colorHorizontal == COLOR_TRIGGER)
           {
            ArrayResize(array_color_line,ArraySize(array_color_line)+1);
            array_color_line[ArraySize(array_color_line)-1].colorLine = colorHorizontal ;
            array_color_line[ArraySize(array_color_line)-1].name  = ObjectName(ChartID(),i,0,OBJ_HLINE);
            string name = array_color_line[ArraySize(array_color_line)-1].name;
            array_color_line[ArraySize(array_color_line)-1].price = ObjectGetDouble(ChartID(),name,OBJPROP_PRICE);
            totalObj++;
           }
     }
   return totalObj;
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//|  Method that print line object                                   |
//|                                                                  |
//+------------------------------------------------------------------+
void print_line(string name, double price, int size,color colorLine)
  {
   ObjectDelete(ChartID(), name);
   ObjectCreate(ChartID(), name,  OBJ_HLINE, 0, TimeCurrent(),  price);
   ObjectSetInteger(ChartID(), name, OBJPROP_COLOR, colorLine);
   ObjectSetInteger(ChartID(), name, OBJPROP_WIDTH, size);

   ObjectSetInteger(ChartID(),name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(ChartID(),name,OBJPROP_SELECTED,true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void add_alert_from_button()
  {


   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   CopyRates(Symbol(), Period(),0,20,rates);



   int posDirectionAlert = ClientArea.get_direction_alert();

   if(posDirectionAlert == 0) // TOPO
     {
      double arrayHigh[];
      CopyHigh(_Symbol,Period(),1,20,arrayHigh);
      int posMax = ArrayMaximum(arrayHigh);
      double priceHigh = rates[posMax].high;
      double priceLow = rates[posMax].low;
      double deslocPrice  = (priceHigh - priceLow) * 2;

      double priceTarget = arrayHigh[posMax];
      print_line("ALERTA_TOPO_"+MAGIC_NUM+"_"+TimeCurrent(),priceTarget + deslocPrice,1,COLOR_TRIGGER);
      //

     }

   if(posDirectionAlert == 1) // FUNDO
     {
      double arrayLow[];
      CopyLow(_Symbol,Period(),1,20,arrayLow);
      int posMin = ArrayMinimum(arrayLow);
      double priceHigh = rates[posMin].high;
      double priceLow = rates[posMin].low;
      double deslocPrice  = (priceHigh - priceLow) * 2;

      double priceTarget = arrayLow[posMin];
      print_line("ALERTA_FUNDO_"+MAGIC_NUM+"_"+TimeCurrent(),priceTarget - deslocPrice,1,COLOR_TRIGGER);
      //

     }



  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void delete_all_orders_opened()
  {

   int total = PositionsTotal();

   if(total == 0)
      return;

   double arrayTktForDell[];
   ArrayFree(arrayTktForDell);
   ArrayResize(arrayTktForDell,true);
   ArrayResize(arrayTktForDell,0);
   ArrayPrint(arrayTktForDell);
   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      string symbol = PositionGetSymbol(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if((_Symbol == symbol && magic == MAGIC_NUM))
        {
         ArrayResize(arrayTktForDell,ArraySize(arrayTktForDell)+1);
         arrayTktForDell[ArraySize(arrayTktForDell)-1] = ticket;
        }
     }

   if(ArraySize(arrayTktForDell) == 0)
      return; // tem ordens abertas mais nenhuma deste bot

   int numOperationOpened = ArraySize(arrayTktForDell);

   int loopCount = 0;
   while(loopCount < ArraySize(arrayTktForDell))
     {
      ulong tkt = arrayTktForDell[loopCount];

      CPositionInfo myPosition;
      if(myPosition.SelectByTicket(tkt) == YES)
         if(trade.PositionClose(tkt) == true)
            loopCount++;
     };
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int get_count_positions_opened()
  {
   int total=PositionsTotal();

   if(total == 0)
      return false;

   int countPos = 0;
   for(int cnt=0; cnt<total; cnt++)
     {
      string symbol = PositionGetSymbol(cnt);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if((_Symbol == symbol  && magic == MAGIC_NUM)|| (_Symbol == symbol  || magic == MAGIC_NUM))
        {
         countPos++;
        }
     }
   return countPos;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool is_position()
  {
   int total=PositionsTotal();

   if(total == 0)
      return false;

   for(int cnt=0; cnt<total; cnt++)
     {
      string symbol = PositionGetSymbol(cnt);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if((_Symbol == symbol  && magic == MAGIC_NUM)|| (_Symbol == symbol  || magic == MAGIC_NUM))
        {
         return true;
        }
     }
   return false;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_profit_runtimer()
  {
   int total=PositionsTotal();

   if(total == 0)
      return 0.0;
   double balance = 0.0;
   for(int cnt=0; cnt<total; cnt++)
     {
      ulong ticket = PositionGetTicket(cnt);
      string symbol = PositionGetSymbol(cnt);
      ulong magic = PositionGetInteger(POSITION_MAGIC);

      if(_Symbol == symbol && magic == MAGIC_NUM)
         balance += (PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP));
     }
   return balance;
  }






CAppDialog           AppWindow;
CMyWndClient         ClientArea;
//+------------------------------------------------------------------+
//|  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx      |
//+------------------------------------------------------------------+
int onInit_panel_datas()
  {


   PrintFormat("Application Rect: Height=%d  Width=%d",AppWindow.Rect().Height(),AppWindow.Rect().Width());
   CRect inner_rect;

   int x1 = 5;
   int y1 = 5;
   int x2 = x1 + 255;
   int y2 = y1+ 375;
   AppWindow.Create(0,NAME_BOT+" v"+VERSION,0,x1,y1,x2,y2);
   PrintFormat("Application Rect: Height=%d  Width=%d",AppWindow.Rect().Height(),AppWindow.Rect().Width());
   inner_rect= ClientArea.GetClientRect(GetPointer(AppWindow));



   PrintFormat("Client Area: Height=%d  Width=%d",inner_rect.Height(),inner_rect.Width());
   ClientArea.Create(0,"MyWndClient",0,0,0,inner_rect.Width(),inner_rect.Height());
   AppWindow.Add(ClientArea);
   AppWindow.Run();
   return(INIT_SUCCEEDED);
  }



//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx      |
//+------------------------------------------------------------------+
void onDeinit_panel_datas(const int reason)
  {
   AppWindow.Destroy(reason);
  }

//+------------------------------------------------------------------+
//|  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx      |
//+------------------------------------------------------------------+
void onChartEvent_panel_datas(const int id,         // event ID
                              const long& lparam,   // event parameter of the long type
                              const double& dparam, // event parameter of the double type
                              const string& sparam)   // event parameter of the string type
  {
   AppWindow.ChartEvent(id,lparam,dparam,sparam);


  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//|  send BUY to market                                              |
//|                                                                  |
//+------------------------------------------------------------------+
ulong buy_market(double takeprofit,double stoploss, double lots, string comment)
  {
   double ask = SymbolInfoDouble(_Symbol,   SYMBOL_ASK);
   if(lots < 0)
      lots = +lots;


   bool ok = trade.Buy(lots, _Symbol,ask, stoploss, takeprofit,comment);
   if(!ok)
     {
      int errorCode = GetLastError();
      Print("lots    "+lots+"   BuyMarket : "+errorCode+"         |        ResultRetcode :  "+trade.ResultRetcode());
      ResetLastError();
      return -1;
     }

   Print("\n===== A MERDADO COMPRA | RESULT RET CODE :  "+trade.ResultRetcode());
   Print("LOTE ENVIADO  :  "+lots);
   ulong order = trade.ResultOrder();

   Print("TKT OFERTA : "+order);
   send_datas_for_clients(order,lots,0,takeprofit,stoploss,"BUY");


   return order;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//|  send SELL to market                                             |
//|                                                                  |
//+------------------------------------------------------------------+
ulong sell_market(double takeprofit,double stoploss, double lots, string comment)
  {
   double bid = SymbolInfoDouble(_Symbol,   SYMBOL_BID);
   if(lots < 0)
      lots = +lots;

   bool ok = trade.Sell(lots, _Symbol,bid, stoploss, takeprofit,comment);
   if(!ok)
     {
      int errorCode = GetLastError();
      Print("lots    "+lots+"    SellMarket : "+errorCode+"         |        ResultRetcode :  "+trade.ResultRetcode());
      ResetLastError();
      return -1;
     }

   Print("\n===== A MERDADO VENDA | RESULT RET CODE :  "+trade.ResultRetcode());
   Print("LOTE ENVIADO  :  "+lots);
   ulong order = trade.ResultOrder();

   Print("TKT OFERTA : "+order);
   send_datas_for_clients(order,lots,0,takeprofit,stoploss,"SELL");

   return order;
  }
struct TRADE_INFO
  {
   double            stoploss;
   double            takeprofit;
   double            lot;
   int               typeConvert;
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string FormingJson(TRADE_INFO &reentrie)
  {
   string str = "";
   str = str +  "{SL:" + string(reentrie.stoploss) + ",TP:" + string(reentrie.takeprofit) + ",LOT:" + string(reentrie.lot) + ",TP_CONVERT:" + string(reentrie.typeConvert) + "}";
   return str;
  }

//+------------------------------------------------------------------+
string GetBackUp(string name)
  {
   string str = "";
   int file_handle = FileOpen(name + ".txt", FILE_READ | FILE_WRITE | FILE_TXT);
   if(file_handle != INVALID_HANDLE)
      str = FileReadString(file_handle);
   FileClose(file_handle);

   return str;
  }

//+------------------------------------------------------------------+
void SetBackUp(string name, string str)
  {
   int filehandle = FileOpen(name + ".txt", FILE_READ | FILE_WRITE | FILE_TXT);
   if(filehandle != INVALID_HANDLE)
     {
      FileWrite(filehandle, str);
      FileFlush(filehandle);
      FileClose(filehandle);
     }
   else
     {
      Print("Erro em FileOpen. Código de erro =", GetLastError());
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Fill(string &arr[], string base, string sep = ",")
  {
   ushort u_sep;
   u_sep = StringGetCharacter(sep, 0);
   int k1 = StringSplit(base, u_sep, arr);
  }
//+------------------------------------------------------------------+
string Deserializer(string str, string Key, string delimiter = ",")
  {
   int pos;
   string key = Key + ":";
   int size_string = StringLen(key);
   if((pos = StringFind(str, key, 0)) > -1)
     {
      int pos_delimiter = StringFind(str, delimiter, pos);
      string res = StringSubstr(str, pos + size_string, pos_delimiter - (pos + size_string));
      return res;
     }
   return "NULL";
  }
//+------------------------------------------------------------------+





//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
