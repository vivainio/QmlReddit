// toolbar.js

// Make current tab visible and others invisible
function setContentOpacity() {
    for (var i = 0; i < views.length; ++i) {
        views[i].opacity = (i == current ? 1 : 0)
    }
}

// Calculate item width to fill the width of the container while maintaining
// minimum item width
function calcTabWidth() {
    var containerWidth = parent.width
    var itemCount = views.length
    var itemWidth = Math.floor(containerWidth / itemCount) >= minimumItemWidth ?
            Math.floor(containerWidth / itemCount) : minimumItemWidth;

    // If content of a tab is wider than the global tab width, the tab
    // will use more space
    for (var i = 0; i < views.length; ++i) {
        if (views[i].contentWidth > itemWidth) {
            containerWidth -= content[i].contentWidth;
            tabCount--;
        }
    }

    if (itemCount > 0) {
        itemWidth = Math.floor(containerWidth / itemCount) >= minimumItemWidth ?
                    Math.floor(containerWidth / itemCount) : minimumItemWidth;
    }

    return itemWidth;
}
