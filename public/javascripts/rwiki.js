// Path to the blank image should point to a valid location on your server
Ext.BLANK_IMAGE_URL = '/resources/images/default/s.gif';

Ext.onReady(function() {
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

    var tree = new Ext.tree.TreePanel({
        useArrows: true,
        autoScroll: true,
        animate: true,
        containerScroll: true,
        border: false,
        dataUrl: '/nodes',

        root: {
            nodeType: 'async',
            text: 'Home',
            draggable: false,
            id: 'src'
        },

        listeners: {
            click: function(node, event) {
                if (node.leaf) {
                    loadContent(node);
                } else {
                    if (node.isExpanded()) {
                        node.collapse();
                    } else {
                        node.expand();
                    }
                }
            }
        }
    });

    tree.getRootNode().expand();

    var actionPanel = new Ext.Panel({
        region: 'west',
        id: 'west-panel',
        title: 'Pages',
        split: true,
        collapsible: true,
        width: 200,
        minSize: 175,
        maxSize: 400,
        margins: '0 0 0 5',
        items: [tree]
    });

    var tabPanel = new Ext.TabPanel({
        region: 'center',
        deferredRender: false,
        activeTab: 0,
        resizeTabs: true,
        minTabWidth: 200,
        enableTabScroll: true,
        defaults: {
            autoScroll: true
        },
        plugins: new Ext.ux.TabCloseMenu()
    });

    var editorPanel = new Ext.Panel({
        region: 'south',
        contentEl: 'edit-container',
        title: 'Editor',
        split: true,
        collapsible: true
    });

    var pagePanel = new Ext.Container({
        region: 'center',
        layout: 'border',
        items: [tabPanel, editorPanel]
    });

    function addTab(id, html) {
        var current = tabPanel.find('id', id)[0];
        if (!current) {
            var pagePanel = new Ext.Container({
                closable: true,
                id: id,
                title: id.replace(/-/g, '/'),
                iconCls: 'tabs',
                html: html
            });

            tabPanel.add(pagePanel).show();
        } else {
            current.show();
        }
    }

    new Ext.Viewport({
        layout: 'border',
        items: [actionPanel, pagePanel]
    });

    function loadContent(node) {
        $.ajax({
            type: 'POST',
            url: '/node/content',
            dataType: 'json',
            data: {
                node: node.id
            },
            success: function(data) {
                $('#editor').val(data.raw);
                addTab(node.id, data.html);
            }
        });
    }

    var timeout = null;
    $('#editor').bind('keyup', function() {
        clearTimeout(timeout);

        timeout = setTimeout(function() {

            var node = tree.getSelectionModel().getSelectedNode();
            var fileName = node.id;
            var content = $('#editor').val();

            $.ajax({
                type: 'POST',
                url: '/node/update',
                dataType: 'json',
                data: {
                    node: fileName,
                    content: content
                },
                success: function(data) {
                    $('#' + node.id).html(data.html);
                }
            });

        }, 900);
    });

});
