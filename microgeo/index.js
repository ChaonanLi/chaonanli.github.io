// microgeo R 包教程页面框架
layui.use(['element', 'layer', 'util'], function () {

    // 组件初始化
    var element = layui.element;
    var layer = layui.layer;
    var util = layui.util;
    var $ = layui.$;
    var isShow = true;

    // 帮助文档列表
    var fileNames = [
        "01.installation.html",
        "02.operate-maps.html",
        "03.visualize-maps.html",
        "04.create-dataset.html",
        "05.download-data.html",
        "06.calculate-traits.html",
        "07.integrate-traits.html",
        "08.data-interpolation.html",
        "09.machine-learning.html",
        "10.extensive-analysis.html",
        "11.case-study-in-QTP.html"
    ];

    // 菜单图标字体
    var iconCodes = [
        "layui-icon-home",
        "layui-icon-export",
        "layui-icon-search",
        "layui-icon-template-1",
        "layui-icon-template",
        "layui-icon-set",
        "layui-icon-note",
        "layui-icon-fire",
        "layui-icon-tree",
        "layui-icon-chart-screen",
        "layui-icon-release"
    ]

    // 头部事件
    util.event('lay-header-event', {
        menuLeft: function (othis) { 
            $('.layui-nav-item span').each(function () {
                if ($(this).is(':hidden')) {
                    $(this).show();
                } else {
                    $(this).hide();
                };
            });
            $('.layui-header span').each(function () {
                if ($(this).is(':hidden')) {
                    $(this).show();
                } else {
                    $(this).hide();
                };
            });
            if (isShow) {
                $('.layui-side.layui-bg-black').attr('lay-status', 'hide');
                $('.layui-side.layui-bg-black').width(60); 
                $('.layui-logo').width(60);
                $('.kit-side-fold i').css('margin-right', '70%'); 
                $('.layui-layout-left').css('left', 60 + 'px');
                $('.layui-body').css('left', 60 + 'px');
                $('.layui-footer').css('left', 60 + 'px');
                $('dd span').each(function () { $(this).hide(); });
                $('#toggle').removeClass('layui-icon-shrink-right')
                $('#toggle').addClass('layui-icon-spread-left')
                isShow = false;
            } else {
                $('.layui-side.layui-bg-black').attr('lay-status', 'display');
                $('.layui-side.layui-bg-black').width(200);
                $('.layui-logo').width(200);
                $('.kit-side-fold i').css('margin-right', '10%');
                $('.layui-layout-left').css('left', 200 + 'px');
                $('.layui-body').css('left', 200 + 'px');
                $('.layui-footer').css('left', 200 + 'px');
                $('dd span').each(function () { $(this).show(); });
                $('#toggle').addClass('layui-icon-shrink-right')
                $('#toggle').removeClass('layui-icon-spread-left')
                isShow = true;
            };
        },
        menuRight: function () {  
            layer.open({
                type: 1,
                title: 'Snapshots',
                content: `
                <div style="padding: 15px;">
                    <img src="img/microgeo-workflow.png" width="100%"><p style="text-align:center">Snapshot-1</p></br>
                    <img src="img/case-1.png" width="100%"><p style="text-align:center">Snapshot-2</p></br>
                    <img src="img/case-2.png" width="100%"><p style="text-align:center">Snapshot-3</p></br>
                    <img src="img/case-3.png" width="100%"><p style="text-align:center">Snapshot-4</p></br>
                </div>`,
                area: ['260px', '100%'],
                offset: 'rt',       // 右上角
                anim: 'slideLeft', // 从右侧抽屉滑出
                shadeClose: true,
                scrollbar: false
            });
        }
    });

    // Citation
    $('#citation').on('click', function(){
        layer.open({
            title: `<i class="layui-icon layui-icon-tips" style="font-family: 'Roboto', sans-serif;"> Citation</i>`,
            type: 1,
            skin: 'layui-layer-molv', 
            area: ['600px', '400px'], //宽高
            content: `<p style="padding:24px; text-align: justify; font-family: 'Roboto', sans-serif;"> 
            If you use the microgeo R package for data processing and publication of a paper, please cite: <br><br> 
            1. https://github.com/ChaonanLi/microgeo<br></br>
            2. https://gitee.com/bioape/microgeo<br></br><br>
            Many thanks!
            </p>`
          });
    })

    // About us
    $('#about_us').on('click', function(){
        layer.open({
            title: `<i class="layui-icon layui-icon-group" style="font-family: 'Roboto', sans-serif;"> About us</i>`,
            type: 1,
            skin: 'layui-layer-molv', 
            area: ['600px', '445px'], //宽高
            content: `
            <div style="padding:24px; text-align: justify;font-family: 'Roboto', sans-serif;">
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    <a href="https://www.researchgate.net/profile/Chaonan-Li-5" target="_blank">Li, Chaonan (李超男)</a> | licn@mtc.edu.cn | <a href="https://zdsys.mtc.edu.cn/" target="_blank">Ecological Security and Protection Key Laboratory of Sichuan Province, Mianyang Normal University (绵阳师范学院生态安全与保护四川省重点实验室)</a>
                </p>
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    <a href="https://www.researchgate.net/profile/Xiangzhen-Li-2" target="_blank">Li, Xiangzhen (李香真)</a> | lixz@fafu.edu.cn | <a href="https://zhxy.fafu.edu.cn/main.htm" target="_blank">College of Resources and Environment, Fujian Agriculture and Forestry University (福建农林大学资源与环境学院)</a>
                </p>
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    Liao, Haijun (廖海君) | lihj@mtc.edu.cn | <a href="https://rhs.mtc.edu.cn//" target="_blank">Engineering Research Center of Chuanxibei RHS Construction at Mianyang Normal University of Sichuan Province (绵阳师范学院川西北乡村人居环境建设工程研究中心)</a>
                </p>
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    Liu Chi (刘驰) | liuchi0426@126.com | <a href="https://zhxy.fafu.edu.cn/main.htm" target="_blank">College of Resources and Environment, Fujian Agriculture and Forestry University (福建农林大学资源与环境学院)</a>
                </p>
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    Yao Minjie (姚敏杰) | yaomj@fafu.edu.cn | <a href="https://zhxy.fafu.edu.cn/main.htm" target="_blank">College of Resources and Environment, Fujian Agriculture and Forestry University (福建农林大学资源与环境学院)</a>
                </p>
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    <a href="https://www.researchgate.net/profile/Lin-Xu-62" target="_blank">Xu, Lin (徐琳)</a> | xulin_lxy@sicau.edu.cn | <a href="https://zdsys.mtc.edu.cn/" target="_blank">National Forestry and Grassland Administration Key Laboratory of Forest Resources Conservation and Ecological Safety on the Upper Reaches of the Yangtze River & Forestry Ecological Engineering in the Upper Reaches of the Yangtze River Key Laboratory of Sichuan Province, Sichuan Agricultural University</a>
                </p>
            </div>`
          });
    })

    // 渲染左侧边栏内容
    var docListContainer = document.getElementById('docListContainer');
    fileNames.forEach(function (fileName, index) {
        var docItem = document.createElement('dd');
        var pageTitle = fileName.replace(/^\d+\./, '').replace(/-/g, ' ').replace('.html', '');
        pageTitle = pageTitle.replace(/^\w/, firstChar => firstChar.toUpperCase());
        docItem.innerHTML = `
        <a href="javascript:;" class="doc-link" data-id="${index}" data-index="${index}" data-title="${pageTitle}" lay-id="${index}">
        <i class="layui-icon ${iconCodes[index]}" style="black"></i>
            <span style="font-family: 'Roboto', sans-serif;">${pageTitle}</span>
        </a>`
        docListContainer.appendChild(docItem);
    });

    // 左侧菜单点击事件
    $('#docListContainer').on('click', '.doc-link', function () {
        var dataid = $(this);
        var index = $(this).data('index');
        var iframeSrc = 'doc/' + fileNames[index];
        $('.layui-tab').removeClass('layui-hide');
        $('#welcome-page').addClass('layui-hide');
        $('.doc-link').removeClass('layui-this'); // 选中的菜单高亮显示
        dataid.addClass('layui-this');            // 选中的菜单高亮显示
        if ($('.layui-tab-title li[lay-id]').length <= 0) {
            tabFunction.tabAdd(iframeSrc, index, dataid.attr('data-title'));
        } else {
            var isExist = false;
            $.each($('.layui-tab-title li[lay-id]'), function () {
                if ($(this).attr('lay-id') == index) isExist = true; 
            });
            if (!isExist) tabFunction.tabAdd(iframeSrc, index, dataid.attr('data-title'));
        }
        tabFunction.tabChange(index); // 转到要打开的tab
    });

    // 定义函数，绑定增加和切换tab的事件
    var tabFunction = {
        tabAdd: function (url, id, name) {
            var loadingIndex = layer.load(2, {shade: [0.3, '#000']});
            element.tabAdd('tables', {
                title: `<i class="layui-icon layui-icon-circle-dot" style="black"></i> <span style="font-family: 'Roboto', sans-serif;">${name}</span>`,
                content: '<div class="loading-wrapper" style="position:relative;"><iframe data-frameid="' + id + '" scrolling="auto" frameborder="0" src="' + url + '" style="width:100%;height:800px"></iframe></div>',
                id: id
            });
            var iframe = $('iframe[data-frameid="' + id + '"]')[0];
            iframe.onload = function () {
                layer.close(loadingIndex);
            };
        },
        tabChange: function (id) { 
            element.tabChange('tables', id); // 根据id切换tab
            var tabs = $('.layui-tab-title li[lay-id]'); // 为选中的tab添加高亮
            tabs.each(function () {
                var tabId = $(this).attr('lay-id');
                var iconColorClass = tabId == id ? 'green' : 'black';
                $(this).find('.layui-icon-circle-dot').removeClass('green black').addClass(iconColorClass);
            });
        }
    }

    // 监听选项卡切换事件
    element.on('tab(tables)', function(data){
        var selectedLayId = $(this).attr('lay-id')
        $('.doc-link').removeClass('layui-this'); 
        $('.doc-link').each(function() { // 为侧边栏添加高亮
            var dataId = $(this).attr('data-id');
            if (dataId === selectedLayId) {
                $(this).addClass('layui-this'); 
            }
        });
        var tabs = $('.layui-tab-title li[lay-id]');
        tabs.each(function () { // 为选中的tab添加高亮
            var tabId = $(this).attr('lay-id');
            var iconColorClass = tabId == selectedLayId ? 'green' : 'black';
            $(this).find('.layui-icon-circle-dot').removeClass('green black').addClass(iconColorClass);
        });
    });

    // 监听选项卡关闭事件
    element.on('tabDelete(tables)', function(data){
        var tabContentLength = $('.layui-tab-content').html().toString().replace(/\s/g, '').length;
        if (tabContentLength == 0){ // 最后一个选项卡
            $('.layui-tab').addClass('layui-hide')
            $('#welcome-page').removeClass('layui-hide')
            $('.doc-link').removeClass('layui-this'); // 取消所有侧边高亮
        }else{
            $('.layui-tab').removeClass('layui-hide')
            $('#welcome-page').addClass('layui-hide')
        }
    });

    // 首页交互
    $('#jupyter-download').on('mouseover', function(){
        $(this).addClass('layui-btn-radius')
    })
    $('#jupyter-download').on('mouseout', function(){
        $(this).removeClass('layui-btn-radius')
    })
});