//+------------------------------------------------------------------+
//|                                                         user.mqh |
//|                                                     DollarKiller |
//|                                 https://github.com/dollarkillerx |
//+------------------------------------------------------------------+
#property copyright "DollarKiller"
#property link      "https://github.com/dollarkillerx"
// 系统 & 用户 & 其他Lib 集合 & 网络

// 系统
class System {
public:
   // 当前设置是否允许交易
   bool settingAllowsTransactions();
   // 当前交易服务器名称
   string serverName();
   // 当前程序名称
   double programName();
   // 当前网络质量
   double networkQuality();
   // 最后一次ping
   double ping();
   // 是否在测试情况下允许
   bool isTest();
};

// 用户
class User {
public:
   // 当前账户是否禁用EA
   bool eaDisabled(); 
   // 当前用户杠杆
   int lever();
   // 当前账户id
   ulong id();
   // 当前账户是否是模拟账户
   bool isDemo();
   // 当前账户是否是竞赛账户
   bool isContest();
   // 当前用户是否是真实账户
   bool isReal();
   // 当前交易商名称
   string brokerName();
};

// 其他
class Lib {
public:
// 时间相关   (时间格式:2020.12.01)
   // 获取本地时间戳
   datetime getLocalTime();
   // 获取本地时间String
   string getLocalTimeString();
   // 获得服务器时间
   datetime getServerTime();
   // 获得服务器时间String
   string getServerTimeString();
   // 时间戳转变为字符串
   string getTimeToString(datetime time);
   // 字符串转变为时间戳
   datetime getStringToTime(string time);
};

// 网络
class Network {
public:
   // post
   // params: url,data,超时,返回数据
   int Post(string url,string data,int timeout,string &resp);
   // get
   int Get(string url,string data,int timeout,string &resp);
};

// System
bool System::settingAllowsTransactions() {
   return TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);
} 
bool System::isTest() {
   return MQLInfoInteger(MQL_TESTER);
}
string System::serverName() {
   return AccountInfoString(ACCOUNT_SERVER);
}
double System::networkQuality() {
   return TerminalInfoDouble(TERMINAL_RETRANSMISSION);
}
double System::ping() {
   return TerminalInfoInteger(TERMINAL_PING_LAST);
}

// User
bool User::eaDisabled() {
   return AccountInfoInteger(ACCOUNT_TRADE_EXPERT);
}
ulong User::id() {
   return AccountInfoInteger(ACCOUNT_LOGIN);
}
bool User::isDemo() {
   return AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO;
}
bool User::isContest() {
   return AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_CONTEST;
}
bool User::isReal() {
   return AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_REAL;
}
string User::brokerName() {
   return AccountInfoString(ACCOUNT_COMPANY);
}


// Lib
datetime Lib::getLocalTime() {
   return TimeLocal();
}
string Lib::getLocalTimeString() {
   return this.getTimeToString(this.getLocalTime());
}
datetime Lib::getServerTime() {
   return TimeTradeServer();
}
string Lib::getServerTimeString() {
   return this.getTimeToString(this.getServerTime());
}
string Lib::getTimeToString(datetime time) {
   return TimeToString(time,TIME_DATE|TIME_MINUTES|TIME_SECONDS);
}
datetime Lib::getStringToTime(string time) {
   return StringToTime(time);
}

// Network
int Network::Post(string url,string data,int timeout,string &resp) {
   string cookie=NULL,headers; 
   char   post[],result[]; 
   StringToCharArray(data,post,0,StringLen(data));
   int res = WebRequest(
   "POST",
   url,
   cookie,
   timeout,
   post,
   result,
   headers);
   if (res == 200) {
      resp =  CharArrayToString(result,0,-1,CP_UTF8);
   }
   return res;
}
int Network::Get(string url,string data,int timeout,string &resp) {
   string cookie=NULL,headers; 
   char   post[],result[]; 
   StringToCharArray(data,post,0,StringLen(data));
   int res = WebRequest(
   "GET",
   url,
   cookie,
   timeout,
   post,
   result,
   headers);
   if (res == 200) {
      resp =  CharArrayToString(result,0,-1,CP_UTF8);
   }
   return res;  
}