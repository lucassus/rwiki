// Path to the blank image should point to a valid location on your server
Ext.BLANK_IMAGE_URL = 'resources/images/default/s.gif';

Ext.onReady(function() {

    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

    new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'west',
            id: 'west-panel', // see Ext.getCmp() below
            title: 'Pages',
            split: true,
            width: 200,
            minSize: 175,
            maxSize: 400,
            collapsible: true,
            margins: '0 0 0 5',
            layout: {
                type: 'accordion',
                animate: true
            },
            items: [{
                contentEl: 'west',
                title: 'Navigation',
                border: false,
                iconCls: 'nav' // see the HEAD section for style used
            }]
        },
        // in this instance the TabPanel is not wrapped by another panel
        // since no title is needed, this Panel is added directly
        // as a Container
        new Ext.TabPanel({
            region: 'center', // a center region is ALWAYS required for border layout
            deferredRender: false,
            activeTab: 0,     // first tab initially active
            resizeTabs      : true,
            minTabWidth     : 200,
            items: [{
                contentEl: 'view-container',
                title: 'View',

                autoScroll: true
            }, {
                contentEl: 'edit-container',
                title: 'Edit',
                autoScroll: true
            }]
        })]
    });

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
                if (!node.leaf) return;

                $.ajax({
                    type: 'POST',
                    url: '/node/content',
                    dataType: 'json',
                    data: {
                        node: node.id
                    },
                    success: function(data, textStatus) {
                        $('#view-container').html(data.html);
                        $('#edit-container').html(data.raw);
                    }
                });
            }
        }
    });

    // render the tree
    tree.render('tree');
    tree.getRootNode().expand();

});
