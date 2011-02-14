Ext.ns('Rwiki.Editor');

Rwiki.Editor.Panel = Ext.extend(Ext.Panel, {
  constructor: function() {
    Ext.apply(this, {
      contentEl: 'editor-container',
      header: false,
      height: 400,

      listeners: {
        resize: function(panel, width, height) {
          var offset = 36 - 25;
          $('.markItUpContainer').height(height - offset);
          var editorOffset = 73 - 25;
          $('#editor').height(height - editorOffset);
        }
      }
    });

    Rwiki.Editor.Panel.superclass.constructor.apply(this, arguments);

    this.editorContainer = $('textarea#editor');
    this.initMarkItUp();
  },

  initMarkItUp: function() {
    var textileSettings = {
      nameSpace: "textile", // Useful to prevent multi-instances CSS conflict
      onShiftEnter: {keepDefault:false, replaceWith:'\n\n'},
      markupSet: [
        {name:'Heading 1', key:'1', openWith:'h1(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
        {name:'Heading 2', key:'2', openWith:'h2(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
        {name:'Heading 3', key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
        {name:'Heading 4', key:'4', openWith:'h4(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
        {name:'Heading 5', key:'5', openWith:'h5(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
        {name:'Heading 6', key:'6', openWith:'h6(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
        {name:'Paragraph', key:'P', openWith:'p(!(([![Class]!]))!). '},
        {separator:'---------------' },
        {name:'Bold', key:'B', closeWith:'*', openWith:'*'},
        {name:'Italic', key:'I', closeWith:'_', openWith:'_'},
        {name:'Stroke through', key:'S', closeWith:'-', openWith:'-'},
        {separator:'---------------' },
        {name:'Bulleted list', openWith:'(!(* |!|*)!)'},
        {name:'Numeric list', openWith:'(!(# |!|#)!)'},
        {separator:'---------------' },
        {name:'Picture', replaceWith:'![![Source:!:http://]!]([![Alternative text]!])!'},
        {name:'Link', openWith:'"', closeWith:'([![Title]!])":[![Link:!:http://]!]', placeHolder:'Your text to link here...' },
        {separator:'---------------' },
        {name:'Quotes', openWith:'bq(!(([![Class]!]))!). '},
        {separator:'---------------' },
        {name:'Code', openWith:'<code>\n', closeWith:'\n</code>', className: 'insert-code'},
        {name:'Ruby Code', openWith:'<code lang="ruby">\n', closeWith:'\n</code>', className: 'insert-code ruby'},
        {name:'JavaScript Code', openWith:'<code lang="javascript">\n', closeWith:'\n</code>', className: 'insert-code javascript'},
        {name:'HTML Code', openWith:'<code lang="html">\n', closeWith:'\n</code>', className: 'insert-code html'},
        {name:'Css Code', openWith:'<code lang="css">\n', closeWith:'\n</code>', className: 'insert-code css'}
      ],
      resizeHandle: false
    };

    this.editorContainer.markItUp(textileSettings);
  },

  initEvents: function() {
    Rwiki.Editor.Panel.superclass.initEvents.apply(this, arguments);

    this.relayEvents(Rwiki.Data.PageManager.getInstance(), ['rwiki:pageLoaded']);
    this.on('rwiki:pageLoaded', this.onPageLoaded);
  },

  onPageLoaded: function(page) {
    this.setContent(page.getRawContent());
    Ext.get('editor-container').unmask();
  },

  setContent: function(content) {
    this.editorContainer.val(content);
  },

  getContent: function() {
    return this.editorContainer.val();
  },

  clearContent: function() {
    this.editorContainer.val('');
  }
});
