/**
 * @Author: DollarKiller
 * @Description: 主函数
 * @Github: https://github.com/dollarkillerx
 * @Date: Create in 10:55 2020-03-08
 */
package main

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"log"
	"os"
)

var Db AuthDb

func init() {
	Db = NewFileDb()
}

func main() {
	if len(os.Args) != 2 {
		log.Fatalln("mql5server.exe 0.0.0.0:8080")
	}
	engine := gin.Default()
	gin.SetMode(gin.ReleaseMode)
	router(engine)

	log.Println(engine.Run(os.Args[1]))
}

func router(app *gin.Engine) {
	app.POST("/auth", auth)
}

func auth(ctx *gin.Context) {
	defer ctx.Request.Body.Close()
	body, e := ioutil.ReadAll(ctx.Request.Body)
	if e != nil {
		log.Println(e)
		ctx.JSON(500, gin.H{})
		return
	}
	auth := &AuthReq{}
	err := json.Unmarshal(body, auth)
	if err != nil {
		log.Println(err)
		ctx.JSON(500, gin.H{})
		return
	}

	s, e := Db.CheckAuth(auth)
	if e != nil {
		log.Println(err)
		ctx.JSON(400, gin.H{})
		return
	}
	fmt.Println(s)
	ctx.JSON(200, AuthResp{OutTime: s})
}
