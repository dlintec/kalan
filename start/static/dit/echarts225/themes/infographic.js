var theme = {
    // é»˜è®¤è‰²æ¿
    color: [
        '#C1232B','#B5C334','#FCCE10','#E87C25','#27727B',
        '#FE8463','#9BCA63','#FAD860','#F3A43B','#60C0DD',
        '#D7504B','#C6E579','#F4E001','#F0805A','#26C0C0'
    ],

    // å›¾è¡¨æ ‡é¢˜
    title: {
        textStyle: {
            fontWeight: 'normal',
            color: '#27727B'          // ä¸»æ ‡é¢˜æ–‡å­—é¢œè‰²
        }
    },

    // å€¼åŸŸ
    dataRange: {
        x:'right',
        y:'center',
        itemWidth: 5,
        itemHeight:25,
        color:['#C1232B','#FCCE10']
    },

    toolbox: {
        color : [
            '#C1232B','#B5C334','#FCCE10','#E87C25','#27727B',
            '#FE8463','#9BCA63','#FAD860','#F3A43B','#60C0DD'
        ],
        effectiveColor : '#ff4500'
    },

    // æç¤ºæ¡†
    tooltip: {
        backgroundColor: 'rgba(50,50,50,0.5)',     // æç¤ºèƒŒæ™¯é¢œè‰²ï¼Œé»˜è®¤ä¸ºé€æ˜Žåº¦ä¸º0.7çš„é»‘è‰²
        axisPointer : {            // åæ ‡è½´æŒ‡ç¤ºå™¨ï¼Œåæ ‡è½´è§¦å‘æœ‰æ•ˆ
            type : 'line',         // é»˜è®¤ä¸ºç›´çº¿ï¼Œå¯é€‰ä¸ºï¼š'line' | 'shadow'
            lineStyle : {          // ç›´çº¿æŒ‡ç¤ºå™¨æ ·å¼è®¾ç½®
                color: '#27727B',
                type: 'dashed'
            },
            crossStyle: {
                color: '#27727B'
            },
            shadowStyle : {                     // é˜´å½±æŒ‡ç¤ºå™¨æ ·å¼è®¾ç½®
                color: 'rgba(200,200,200,0.3)'
            }
        }
    },

    // åŒºåŸŸç¼©æ”¾æŽ§åˆ¶å™¨
    dataZoom: {
        dataBackgroundColor: 'rgba(181,195,52,0.3)',            // æ•°æ®èƒŒæ™¯é¢œè‰²
        fillerColor: 'rgba(181,195,52,0.2)',   // å¡«å……é¢œè‰²
        handleColor: '#27727B'    // æ‰‹æŸ„é¢œè‰²
    },

    // ç½‘æ ¼
    grid: {
        borderWidth:0
    },

    // ç±»ç›®è½´
    categoryAxis: {
        axisLine: {            // åæ ‡è½´çº¿
            lineStyle: {       // å±žæ€§lineStyleæŽ§åˆ¶çº¿æ¡æ ·å¼
                color: '#27727B'
            }
        },
        splitLine: {           // åˆ†éš”çº¿
            show: false
        }
    },

    // æ•°å€¼åž‹åæ ‡è½´é»˜è®¤å‚æ•°
    valueAxis: {
        axisLine: {            // åæ ‡è½´çº¿
            show: false
        },
        splitArea : {
            show: false
        },
        splitLine: {           // åˆ†éš”çº¿
            lineStyle: {       // å±žæ€§lineStyleï¼ˆè¯¦è§lineStyleï¼‰æŽ§åˆ¶çº¿æ¡æ ·å¼
                color: ['#ccc'],
                type: 'dashed'
            }
        }
    },

    polar : {
        axisLine: {            // åæ ‡è½´çº¿
            lineStyle: {       // å±žæ€§lineStyleæŽ§åˆ¶çº¿æ¡æ ·å¼
                color: '#ddd'
            }
        },
        splitArea : {
            show : true,
            areaStyle : {
                color: ['rgba(250,250,250,0.2)','rgba(200,200,200,0.2)']
            }
        },
        splitLine : {
            lineStyle : {
                color : '#ddd'
            }
        }
    },

    timeline : {
        lineStyle : {
            color : '#27727B'
        },
        controlStyle : {
            normal : { color : '#27727B'},
            emphasis : { color : '#27727B'}
        },
        symbol : 'emptyCircle',
        symbolSize : 3
    },

    // æŠ˜çº¿å›¾é»˜è®¤å‚æ•°
    line: {
        itemStyle: {
            normal: {
                borderWidth:2,
                borderColor:'#fff',
                lineStyle: {
                    width: 3
                }
            },
            emphasis: {
                borderWidth:0
            }
        },
        symbol: 'circle',  // æ‹ç‚¹å›¾å½¢ç±»åž‹
        symbolSize: 3.5           // æ‹ç‚¹å›¾å½¢å¤§å°
    },

    // Kçº¿å›¾é»˜è®¤å‚æ•°
    k: {
        itemStyle: {
            normal: {
                color: '#C1232B',       // é˜³çº¿å¡«å……é¢œè‰²
                color0: '#B5C334',      // é˜´çº¿å¡«å……é¢œè‰²
                lineStyle: {
                    width: 1,
                    color: '#C1232B',   // é˜³çº¿è¾¹æ¡†é¢œè‰²
                    color0: '#B5C334'   // é˜´çº¿è¾¹æ¡†é¢œè‰²
                }
            }
        }
    },

    // æ•£ç‚¹å›¾é»˜è®¤å‚æ•°
    scatter: {
        itemStyle: {
            normal: {
                borderWidth:1,
                borderColor:'rgba(200,200,200,0.5)'
            },
            emphasis: {
                borderWidth:0
            }
        },
        symbol: 'star4',    // å›¾å½¢ç±»åž‹
        symbolSize: 4        // å›¾å½¢å¤§å°ï¼ŒåŠå®½ï¼ˆåŠå¾„ï¼‰å‚æ•°ï¼Œå½“å›¾å½¢ä¸ºæ–¹å‘æˆ–è±å½¢åˆ™æ€»å®½åº¦ä¸ºsymbolSize * 2
    },

    // é›·è¾¾å›¾é»˜è®¤å‚æ•°
    radar : {
        symbol: 'emptyCircle',    // å›¾å½¢ç±»åž‹
        symbolSize:3
        //symbol: null,         // æ‹ç‚¹å›¾å½¢ç±»åž‹
        //symbolRotate : null,  // å›¾å½¢æ—‹è½¬æŽ§åˆ¶
    },

    map: {
        itemStyle: {
            normal: {
                areaStyle: {
                    color: '#ddd'
                },
                label: {
                    textStyle: {
                        color: '#C1232B'
                    }
                }
            },
            emphasis: {                 // ä¹Ÿæ˜¯é€‰ä¸­æ ·å¼
                areaStyle: {
                    color: '#fe994e'
                },
                label: {
                    textStyle: {
                        color: 'rgb(100,0,0)'
                    }
                }
            }
        }
    },

    force : {
        itemStyle: {
            normal: {
                linkStyle : {
                    color : '#27727B'
                }
            }
        }
    },

    chord : {
        itemStyle : {
            normal : {
                borderWidth: 1,
                borderColor: 'rgba(128, 128, 128, 0.5)',
                chordStyle : {
                    lineStyle : {
                        color : 'rgba(128, 128, 128, 0.5)'
                    }
                }
            },
            emphasis : {
                borderWidth: 1,
                borderColor: 'rgba(128, 128, 128, 0.5)',
                chordStyle : {
                    lineStyle : {
                        color : 'rgba(128, 128, 128, 0.5)'
                    }
                }
            }
        }
    },

    gauge : {
        center:['50%','80%'],
        radius:'100%',
        startAngle: 180,
        endAngle : 0,
        axisLine: {            // åæ ‡è½´çº¿
            show: true,        // é»˜è®¤æ˜¾ç¤ºï¼Œå±žæ€§showæŽ§åˆ¶æ˜¾ç¤ºä¸Žå¦
            lineStyle: {       // å±žæ€§lineStyleæŽ§åˆ¶çº¿æ¡æ ·å¼
                color: [[0.2, '#B5C334'],[0.8, '#27727B'],[1, '#C1232B']],
                width: '40%'
            }
        },
        axisTick: {            // åæ ‡è½´å°æ ‡è®°
            splitNumber: 2,   // æ¯ä»½splitç»†åˆ†å¤šå°‘æ®µ
            length: 5,        // å±žæ€§lengthæŽ§åˆ¶çº¿é•¿
            lineStyle: {       // å±žæ€§lineStyleæŽ§åˆ¶çº¿æ¡æ ·å¼
                color: '#fff'
            }
        },
        axisLabel: {           // åæ ‡è½´æ–‡æœ¬æ ‡ç­¾ï¼Œè¯¦è§axis.axisLabel
            textStyle: {       // å…¶ä½™å±žæ€§é»˜è®¤ä½¿ç”¨å…¨å±€æ–‡æœ¬æ ·å¼ï¼Œè¯¦è§TEXTSTYLE
                color: '#fff',
                fontWeight:'bolder'
            }
        },
        splitLine: {           // åˆ†éš”çº¿
            length: '5%',         // å±žæ€§lengthæŽ§åˆ¶çº¿é•¿
            lineStyle: {       // å±žæ€§lineStyleï¼ˆè¯¦è§lineStyleï¼‰æŽ§åˆ¶çº¿æ¡æ ·å¼
                color: '#fff'
            }
        },
        pointer : {
            width : '40%',
            length: '80%',
            color: '#fff'
        },
        title : {
          offsetCenter: [0, -20],       // x, yï¼Œå•ä½px
          textStyle: {       // å…¶ä½™å±žæ€§é»˜è®¤ä½¿ç”¨å…¨å±€æ–‡æœ¬æ ·å¼ï¼Œè¯¦è§TEXTSTYLE
            color: 'auto',
            fontSize: 20
          }
        },
        detail : {
            offsetCenter: [0, 0],       // x, yï¼Œå•ä½px
            textStyle: {       // å…¶ä½™å±žæ€§é»˜è®¤ä½¿ç”¨å…¨å±€æ–‡æœ¬æ ·å¼ï¼Œè¯¦è§TEXTSTYLE
                color: 'auto',
                fontSize: 40
            }
        }
    },

    textStyle: {
        fontFamily: 'å¾®è½¯é›…é»‘, Arial, Verdana, sans-serif'
    }
};
