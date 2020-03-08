/**
 * @Author: DollarKiller
 * @Description: 一些定义
 * @Github: https://github.com/dollarkillerx
 * @Date: Create in 10:55 2020-03-08
 */
package main

type AuthReq struct {
	Username string `json:"username"`
	Password string `json:"password"`
	Mt5ID    string `json:"mt5_id"`
}

type AuthResp struct {
	OutTime string `json:"out_time"`
}
