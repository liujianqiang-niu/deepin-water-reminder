import QtQuick

Rectangle { id:root; color:"transparent"; anchors.fill:parent
    property real sw:Screen.width; property real sh:Screen.height

    // 星云层 — 大面积柔和渐变光团
    Rectangle { id:nebula1; x:sw*0.1; y:sh*0.2; width:sw*0.6; height:sw*0.5; radius:width/2
        gradient: Gradient {
            GradientStop { position:0.0; color:"#1a0033" }
            GradientStop { position:0.25; color:"#0d1a44" }
            GradientStop { position:0.5; color:"#0a2266" }
            GradientStop { position:1.0; color:"transparent" }
        }
        opacity:0.5
        SequentialAnimation on opacity { loops:Animation.Infinite
            NumberAnimation{from:0.4;to:0.6;duration:10000;easing.type:Easing.InOutSine}
            NumberAnimation{from:0.6;to:0.4;duration:10000;easing.type:Easing.InOutSine}
        }
    }
    Rectangle { id:nebula2; x:sw*0.4; y:sh*0.3; width:sw*0.5; height:sw*0.45; radius:width/2
        gradient: Gradient {
            GradientStop { position:0.0; color:"#220044" }
            GradientStop { position:0.3; color:"#1a1166" }
            GradientStop { position:0.6; color:"#0a1144" }
            GradientStop { position:1.0; color:"transparent" }
        }
        opacity:0.4
        SequentialAnimation on x { loops:Animation.Infinite
            NumberAnimation{from:sw*0.4;to:sw*0.45;duration:12000;easing.type:Easing.InOutSine}
            NumberAnimation{from:sw*0.45;to:sw*0.4;duration:12000;easing.type:Easing.InOutSine}
        }
        SequentialAnimation on opacity { loops:Animation.Infinite
            NumberAnimation{from:0.3;to:0.5;duration:8000;easing.type:Easing.InOutSine}
            NumberAnimation{from:0.5;to:0.3;duration:8000;easing.type:Easing.InOutSine}
        }
    }

    // 中心辉光
    Rectangle { width:sw*0.35; height:sw*0.35; x:sw*0.35; y:sh*0.25; radius:width/2
        gradient: Gradient {
            GradientStop { position:0.0; color:"#ffffff" }
            GradientStop { position:0.04; color:"#ddeeff" }
            GradientStop { position:0.15; color:"#6699cc" }
            GradientStop { position:0.4; color:"#112244" }
            GradientStop { position:1.0; color:"transparent" }
        }
        opacity:0.6
    }

    // 远景星尘 — 细密、低亮度
    Repeater { model:200
        Rectangle { id:dust; property real a:Math.random()*Math.PI*2
            property real d:10+Math.random()*sw*0.5; property real sz:0.5+Math.random()*1.5
            width:sz; height:sz; radius:sz/2; color:"#8899bb"
            x:sw/2+Math.cos(a)*d-sz/2; y:sh/2+Math.sin(a)*d-sz/2; opacity:0.1+Math.random()*0.2
            SequentialAnimation { running:true; loops:Animation.Infinite
                NumberAnimation{target:dust;property:"opacity";from:0.05;to:0.3;duration:2000+Math.random()*3000;easing.type:Easing.InOutSine}
                NumberAnimation{target:dust;property:"opacity";from:0.3;to:0.05;duration:2000+Math.random()*3000;easing.type:Easing.InOutSine}
            }
        }
    }

    // 中景星星 — 明亮闪烁
    Repeater { model:80
        Rectangle { id:star; property real a:Math.random()*Math.PI*2
            property real d:20+Math.random()*sw*0.45; property real sp:10000+Math.random()*25000
            property real sz:1.5+Math.random()*3
            width:sz; height:sz; radius:sz/2
            color:Math.random()>0.6?"#aaccff":(Math.random()>0.5?"#ffffcc":"#ffffff")
            x:sw/2+Math.cos(a)*d-sz/2; y:sh/2+Math.sin(a)*d-sz/2
            SequentialAnimation { running:true; loops:Animation.Infinite
                NumberAnimation{target:star;property:"a";to:star.a+Math.PI*2;duration:sp;easing.type:Easing.Linear}
            }
            SequentialAnimation { running:true; loops:Animation.Infinite
                NumberAnimation{target:star;property:"opacity";from:0.1;to:1.0;duration:500+Math.random()*1500;easing.type:Easing.InOutSine}
                NumberAnimation{target:star;property:"opacity";from:1.0;to:0.1;duration:500+Math.random()*1500;easing.type:Easing.InOutSine}
            }
        }
    }

    // 流星 — 带尾迹的快速移动
    Repeater { model:6
        Rectangle { id:meteor; property real msx:Math.random()*sw*0.7; property real msy:Math.random()*sh*0.3
            width:2.5; height:80+Math.random()*60; rotation:-30-Math.random()*10
            x:msx; y:msy; opacity:0
            gradient:Gradient{GradientStop{position:0.0;color:"#ffffff"}GradientStop{position:0.08;color:"#ccddff"}GradientStop{position:0.3;color:"#6688cc"}GradientStop{position:1.0;color:"transparent"}}
            SequentialAnimation { running:true; loops:Animation.Infinite
                PauseAnimation{duration:3000+Math.random()*8000}
                ParallelAnimation {
                    NumberAnimation{target:meteor;property:"x";to:msx+sw*0.6;duration:350+Math.random()*200}
                    NumberAnimation{target:meteor;property:"y";to:msy+sh*0.25;duration:350+Math.random()*200}
                }
                SequentialAnimation {
                    NumberAnimation{target:meteor;property:"opacity";from:0;to:1;duration:40}
                    NumberAnimation{target:meteor;property:"opacity";from:1;to:0;duration:310+Math.random()*200}
                }
            }
        }
    }

    // 十字星芒 — 少数极亮星
    Repeater { model:5
        Item { id:sparkle; property real spx:sw*(0.15+Math.random()*0.7); property real spy:sh*(0.15+Math.random()*0.5)
            property real sz:15+Math.random()*20; opacity:0
            x:spx; y:spy
            Rectangle { width:sparkle.sz*2; height:1.5; anchors.centerIn:parent; color:"#ffffff"; radius:1 }
            Rectangle { width:1.5; height:sparkle.sz*2; anchors.centerIn:parent; color:"#ffffff"; radius:1 }
            SequentialAnimation { running:true; loops:Animation.Infinite
                PauseAnimation{duration:5000+Math.random()*10000}
                SequentialAnimation {
                    NumberAnimation{target:sparkle;property:"opacity";from:0;to:0.8;duration:300}
                    NumberAnimation{target:sparkle;property:"opacity";from:0.8;to:0.6;duration:1500}
                    NumberAnimation{target:sparkle;property:"opacity";from:0.6;to:0;duration:500}
                }
            }
        }
    }
}
