layui.use(['element', 'layer', 'util'], function () {
    var element = layui.element;
    var layer = layui.layer;
    var util = layui.util;
    var $ = layui.$;
    var isShow = true;

    // 处理文档列表
    var fileNames = [
        "00.introduction.html",
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
        
        // 添加其他文件名称
    ];

    var docListContainer = document.getElementById('docListContainer');

    fileNames.forEach(function (fileName, index) {
        var docItem = document.createElement('dd');
        docItem.innerHTML = '<a href="javascript:;" class="doc-link" data-index="' + index + '">' + fileName + '</a>';
        docListContainer.appendChild(docItem);
    });

// 为文档条目绑定点击事件
$('#docListContainer').on('click', '.doc-link', function () {
    var index = $(this).data('index');
    var iframeSrc = 'doc/' + fileNames[index];

    // 显示加载动画
    var loadingIndex = layer.load(0, {shade: false});

    // 加载对应的 HTML 文件内容到 iframe
    $('#docContent').attr('src', iframeSrc);

    // 等待 iframe 加载完成后隐藏加载动画
    var iframe = document.getElementById('docContent');
    iframe.onload = function () {
        // 隐藏加载动画
        layer.close(loadingIndex);
    };

    // 添加高亮样式
    $('.doc-link').removeClass('active');
    $(this).addClass('active');
});


    // 自适应 iframe 高度
    var iframe = document.getElementById('docContent');
    iframe.addEventListener('load', function () {
        var receivedMessage = function (event) {
            if (event.origin !== window.location.origin) {
                return;
            }
            iframe.style.height = event.data.height + 'px';
        };

        window.addEventListener('message', receivedMessage, false);
    });
});