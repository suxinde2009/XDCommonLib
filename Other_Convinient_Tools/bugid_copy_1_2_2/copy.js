chrome.extension.onRequest.addListener(
    function(request, sender, sendResponse) {
        if (request.isSucess == "ok") {
            var bugId = '',
                bugTit = '',
                str = '';
            var idObj = document.getElementById('BugId');
            if (idObj) {
                bugId = idObj.innerText
            };
            var titObj = document.getElementById('BugTitle');
            if (titObj) {
                bugTit = titObj.value;
            };
            if (bugId != '' && bugTit != '') {
                str = '【Bugfix-' + bugId + '】：' + '  ' + bugTit + '\n' + '【产生原因】：代码逻辑\n【解决方案】：修改代码\n【影响范围】：该bug本身';
            } else {
                str = '';
            }
            sendResponse({ copyCont: str });
        }
    }
);

