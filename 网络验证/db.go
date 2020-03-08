/**
 * @Author: DollarKiller
 * @Description: 数据存储部分&热更新
 * @Github: https://github.com/dollarkillerx
 * @Date: Create in 10:55 2020-03-08
 */
package main

import (
	"encoding/json"
	"errors"
	"github.com/dollarkillerx/hotload"
	"io/ioutil"
	"log"
	"sync"
)

type AuthDb interface {
	CheckAuth(auth *AuthReq) (string, error)
}

type authDataStruct struct {
	password string
	mql5ID   string
	time     string
}
type authJson struct {
	Username string `json:"username"`
	Password string `json:"password"`
	Mql5ID   string `json:"mql5_id"`
	Time     string `json:"time"`
}

type fileAuth struct {
	data map[string]*authDataStruct
}

func NewFileDb() AuthDb {
	return &fileAuth{}
}

var oc sync.Once

func (f *fileAuth) CheckAuth(auth *AuthReq) (string, error) {
	oc.Do(func() {
		load := hotload.New()
		go load.Load("db.json", f.loadFile)
	})
	dataStruct, bool := f.data[auth.Username]
	if !bool {
		return "", errors.New("password not or user not")
	}
	if dataStruct.password == auth.Password && dataStruct.mql5ID == auth.Mt5ID {
		return dataStruct.time, nil
	}
	return "", errors.New("mt5ID error")
}

func (f *fileAuth) loadFile(file string) {
	bytes, e := ioutil.ReadFile(file)
	if e != nil {
		log.Fatalln("open file err: ",e)
	}
	db := make([]authJson, 0)
	e = json.Unmarshal(bytes, &db)
	if e != nil {
		log.Fatalln("Json Unmarshal err: ",e)
	}
	mapData := make(map[string]*authDataStruct, 0)
	for _, v := range db {
		mapData[v.Username] = &authDataStruct{
			password: v.Password,
			mql5ID:   v.Mql5ID,
			time:     v.Time,
		}
	}
	f.data = mapData
}
