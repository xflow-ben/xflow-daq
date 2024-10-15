try
stop(t);
end
try
t.userData.BBB.UserData.startStop = "stop";
end
try
t.UserData.BBB.UserData.socket.close();
end
try
t.UserData.d.stop;
end
try
t.UserData.d.delete;
end
try
    delete(timerfind)
end
clear t
