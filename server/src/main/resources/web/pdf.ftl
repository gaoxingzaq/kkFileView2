<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>PDF预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/base64.min.js" type="text/javascript"></script>
    <style>
        /* 简单全屏布局，无滚动条 */
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
        }
        iframe {
            width: 100%;
            height: 100%;
            border: none;
            display: block;
        }
        .img-preview {
            position: fixed;
            bottom: 20px;
            right: 20px;
            cursor: pointer;
            z-index: 999;
            width: 48px;
            height: 48px;
        }
    </style>
</head>
<body>

<#if pdfUrl?contains("http://") || pdfUrl?contains("https://")>
    <#assign finalUrl="${pdfUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${pdfUrl}">
</#if>

<iframe id="pdfFrame" src="about:blank"></iframe>

<#if "false" == switchDisabled>
    <img class="img-preview" src="images/jpg.svg" alt="使用图片预览" title="使用图片预览" onclick="goForImage()"/>
</#if>

<script type="text/javascript">
    // 计算最终 PDF 地址（支持代理）
    var url = '${finalUrl}';
    var kkagent = '${kkagent}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (kkagent === 'true' || !url.startsWith(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url)) + "&key=${kkkey}";
    }

    // ========== 参数配置区（便于修改） ==========
    var params = {
        file: url,
        disablepresentationmode: '${pdfPresentationModeDisable}',
        disableopenfile: '${pdfOpenFileDisable}',
        disableprint: '${pdfPrintDisable}',
        disabledownload: '${pdfDownloadDisable}',
        disablebookmark: '${pdfBookmarkDisable}',
        disableediting: '${pdfDisableEditing}',
        pdfhighlightall: '${pdfhighlightAll}',
        watermarktxt: '${watermarkTxt}',
        pagemode: 'thumbs'   // 缩略图模式
    };
    // ===========================================

    // 使用原生 JS 构建查询字符串
    var queryString = Object.keys(params)
        .map(function(key) {
            return encodeURIComponent(key) + '=' + encodeURIComponent(params[key]);
        })
        .join('&');

    // 构建完整 viewer URL（保留锚点 #page）
    var viewerUrl = baseUrl + "pdfjs/web/viewer.html?" + queryString + "#page=${page}";

    // 设置 iframe 地址
    var iframe = document.getElementById('pdfFrame');
    iframe.src = viewerUrl;

    // 图片预览切换
    function goForImage() {
        var href = window.location.href;
        if (href.indexOf("officePreviewType=pdf") !== -1) {
            href = href.replace("officePreviewType=pdf", "officePreviewType=image");
        } else {
            href += (href.indexOf('?') === -1 ? '?' : '&') + "officePreviewType=image";
        }
        window.location.href = href;
    }

    // 水印初始化（保持原有逻辑）
    window.onload = function () {
        if (typeof initWaterMark === 'function') {
            initWaterMark();
        }
    };
</script>
</body>
</html>