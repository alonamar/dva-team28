window.onload = function() {
    let url = "https://public.tableau.com/views/Houston-311-Exploratory-Analysis1/ComplaintVolumeAnalysis?:display_count=y&:origin=viz_share_link";
	let element = "vizContainer";
    initViz(url, element);
};

function initViz(url, element) {
    var containerDiv = document.getElementById(element);
    var options = {
        hideTabs: false,
        hideToolbar: false,
        width: containerDiv.offsetWidth,
        height: "700px",
        onFirstInteractive: function () {
            // The viz is now ready and can be safely used.
        }
    };
    //var viz = new tableau.Viz(containerDiv, url);
    var viz = new tableau.Viz(containerDiv, url, options);
}