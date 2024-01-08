// microgeo R 包教程页面框架
layui.use(['element', 'layer', 'util'], function () {

    // 组件初始化
    var element = layui.element;
    var layer = layui.layer;
    var util = layui.util;
    var $ = layui.$;
    var isShow = true;
    var fileNames = [
        "01.install-microgeo-package-and-dependencies.html",
        "02.read-and-operate-map-data.html",
        "03.visualize-geographic-map.html",
        "04.create-microgeo-dataset.html",
        "05.collect-spatial-data.html",
        "06.calculate-biogeographic-traits.html",
        "07.merge-traits-with-a-map.html",
        "08.spatial-interpolation.html",
        "09.machine-learning.html",
        "10.interface-for-extensive-analysis.html"
    ];

    // 头部事件
    util.event('lay-header-event', {
        menuLeft: function (othis) { 
            // 定义一个标志位，选择出所有的span，并判断是不是hidden
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
            // layer.msg('展开左侧菜单的操作', { icon: 0 });
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
                </div>,
                `,
                area: ['260px', '100%'],
                offset: 'rt', // 右上角
                anim: 'slideLeft', // 从右侧抽屉滑出
                shadeClose: true,
                scrollbar: false
            });
        }
    });
    $('#citation').on('click', function(){
        layer.open({
            title: '<i class="layui-icon layui-icon-tips"></i> Citation',
            type: 1,
            skin: 'layui-layer-molv', 
            area: ['380px', '240px'], //宽高
            content: `<p style="padding:15px; text-align: justify;"> If you use microgeo for data processing and publication of a research paper, 
            please cite: <br><br> 
            1. https://github.com/ChaonanLi/microgeo<br></br>
            2. https://gitee.com/bioape/microgeo<br></br><br>
            Many thanks!
            </p>`
          });
    })
    $('#about_us').on('click', function(){
        layer.open({
            title: '<i class="layui-icon layui-icon-group"></i> About us',
            type: 1,
            skin: 'layui-layer-molv', 
            area: ['600px', '400px'], //宽高
            content: `
            <div style="padding:25px; text-align: justify;">
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    <a href="https://www.researchgate.net/profile/Chaonan-Li-5" target="_blank">Li, Chaonan (李超男)</a> | licn@mtc.edu.cn | <a href="https://zdsys.mtc.edu.cn/" target="_blank">Ecological Security and Protection Key Laboratory of Sichuan Province, Mianyang Normal University (绵阳师范学院生态安全与保护四川省重点实验室)</a>
                </p>
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    Liu Chi (刘驰) | liuchi0426@126.com | <a href="https://zhxy.fafu.edu.cn/main.htm" target="_blank">College of Resources and Environment, Fujian Agriculture and Forestry University (福建农林大学资源与环境学院)</a>
                </p>
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    Liao, Haijun (廖海君) | lihj@mtc.edu.cn | <a href="https://rhs.mtc.edu.cn//" target="_blank">Engineering Research Center of Chuanxibei RHS Construction at Mianyang Normal University of Sichuan Province (绵阳师范学院川西北乡村人居环境建设工程研究中心)</a>
                </p>
                <p style="text-align:justify; padding-bottom: 20px;">
                    <i class="layui-icon layui-icon-circle-dot"></i>
                    <a href="https://www.researchgate.net/profile/Xiangzhen-Li-2" target="_blank">Li, Xiangzhen (李香真)</a> | lixz@fafu.edu.cn | <a href="https://zhxy.fafu.edu.cn/main.htm" target="_blank">College of Resources and Environment, Fujian Agriculture and Forestry University (福建农林大学资源与环境学院)</a>
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
        <i class="layui-icon layui-icon-circle" style="black"></i>
            <span>${pageTitle}</span>
        </a>`
        docListContainer.appendChild(docItem);
    });

    $('#docListContainer').on('mouseover', '.doc-link', function () {
        var title = $(this).attr('data-title');
        var sidebarStatus = $('.layui-side.layui-bg-black').attr('lay-status');
        if (sidebarStatus === 'display'){
            layer.tips(title, this, {
                tips: [2, "rgb(47, 54, 60)"],
                time: 0,
                area: ['auto', 'auto'],
                offset: 'auto' 
            });
        }
    });
    $('#docListContainer').on('mouseout', '.doc-link', function () {
        layer.closeAll()
    })

    // 左侧菜单点击事件
    $('#docListContainer').on('click', '.doc-link', function () {
        var dataid = $(this);
        var index = $(this).data('index');
        var iframeSrc = 'doc/' + fileNames[index];
        $('.doc-link').removeClass('layui-this'); // 选中的菜单高亮显示
        dataid.addClass('layui-this'); // 选中的菜单高亮显示
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
            // Show loading overlay
            var loadingIndex = layer.load(2, {shade: [0.3, '#000']});
        
            // Add tab with loading content
            element.tabAdd('tables', {
                title: `<i class="layui-icon layui-icon-circle-dot" style="black"></i> ${name}`,
                content: '<div class="loading-wrapper" style="position:relative;"><iframe data-frameid="' + id + '" scrolling="auto" frameborder="0" src="' + url + '" style="width:100%;height:800px"></iframe></div>',
                id: id
            });
        
            // Get the iframe element
            var iframe = $('iframe[data-frameid="' + id + '"]')[0];
        
            // Attach load event to the iframe
            iframe.onload = function () {
                // Hide loading overlay after content is loaded
                layer.close(loadingIndex);
            };
        },
        tabChange: function (id) { // 根据id切换tab
            element.tabChange('tables', id);

            // 为选中的tab添加高亮
            var tabs = $('.layui-tab-title li[lay-id]');
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

        // 为侧边栏添加高亮
        $('.doc-link').removeClass('layui-this');
        $('.doc-link').each(function() {
            var dataId = $(this).attr('data-id');
            if (dataId === selectedLayId) {
                $(this).addClass('layui-this'); 
            }
        });

        // 为选中的tab添加高亮
        var tabs = $('.layui-tab-title li[lay-id]');
        tabs.each(function () {
            var tabId = $(this).attr('lay-id');
            var iconColorClass = tabId == selectedLayId ? 'green' : 'black';
            $(this).find('.layui-icon-circle-dot').removeClass('green black').addClass(iconColorClass);
        });
    });

    // 页面加载完毕时创建默认tab
    $(document).ready(function () {
        var defaultTabId = 0;
        var defaultTabUrl = 'doc/' + fileNames[defaultTabId];
        var defaultTabTitle = fileNames[defaultTabId].replace(/^\d+\./, '').replace(/-/g, ' ').replace('.html', '');
        defaultTabTitle = defaultTabTitle.replace(/^\w/, firstChar => firstChar.toUpperCase());
        tabFunction.tabAdd(defaultTabUrl, defaultTabId, defaultTabTitle);
        tabFunction.tabChange(defaultTabId);
    });
});