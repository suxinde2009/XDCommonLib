window.onload = function() {
    document.getElementById('copy').click();
};
document.getElementById('copy').onclick = function() {
    chrome.tabs.getSelected(null, function(tab) {
        chrome.tabs.sendRequest(tab.id, { "isSucess": "ok" }, function(response) {
            var obj = document.getElementById('cont');
            if (response.copyCont == '') {
                document.getElementById('copyTip').innerText = '前往http://bug.meitu.com/进入具体bug详情页使用该复制功能 '
            }else{
                obj.value = response.copyCont;
	            obj.select();
	            document.execCommand("copy", false, null);
            }
            
        });
    });

}
