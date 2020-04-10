#!/bin/bash
# 生成本机公钥私钥
auto_ssh_keygen(){
        expect -c "set timeout -1;
                spawn ssh-keygen -t dsa;
                expect {
                        *id_dsa)*       {send -- \r;exp_continue;}
                        *passphrase)*   {send -- \r;exp_continue;}
                        *again:*        {send -- \r;exp_continue;}
                        eof     {exit 0;}
                }";
}
 
# 执行生成公钥私钥脚本
auto_ssh_keygen
 
# 实现将本机的公钥发送到其他机器的功能
# 需要将其他机器的用户名，密码，IP或DNS传入
# ssh-copy-id user@server 将本机公钥发送到其他机器
auto_ssh_copy_id(){
        expect -c "set timeout -1;
                spawn ssh-copy-id $2@$1;
                expect {
                        *(yes/no)*      {send -- yes\r;exp_continue;}
                        *password*      {send -- $3\r;exp_continue;}
                        eof             {exit 0;}       
                }";
}
 
# 根据配置文件，将公钥依次发送到各个机器中
ssh_copy_id_to_all(){
        cat $1 | while read line
        do
                IP=`echo $line | cut -d ' ' -f 1`
                USERNAME=`echo $line | cut -d ' ' -f 2`
                PASSWORD=`echo $line | cut -d ' ' -f 3`
                auto_ssh_copy_id $IP $USERNAME $PASSWORD
        done
}
 
# 执行将公钥私钥发送到各个机器函数
ssh_copy_id_to_all $1
