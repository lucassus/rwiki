//Define the namespace
Ext.ns('Ext.ux');
/**
 * @class Ext.ux.MessageBox
 * @author    Otavio Augusto R. Fernandes
 * @version   1.1.1
 * @copyright (c) 2010, by Otavio Augusto R. Fernandes
 * @date      22. February 2010
 * @version   $Id: Ext.ux.MessageBox.Flash.js 50 2010-02-22 16:34:25Z oaugusts $
 * <p>Utility class for generating different styles of flash message boxes.  The alias Ext.ux.Msg can also be used.<p/>
 * <p>Example usage:</p>
 *<pre><code>
// Show a success flash message
Ext.ux.Msg.flash({
   msg: 'Done!',
   type: 'success'
});
</code></pre>
 * @singleton
 */
Ext.ux.MessageBox = function(){
    var msgCt;

    function createBox(config){
        var tpl = '<div class="flash">' +
            '<div class="flash">' +
            '<table class="box ' + config.type + '" cellspacing="0" cellpadding="0"';

            if (!config.autoWidth)
               tpl += 'style="width:' + config.width + '"';
            
        tpl +='><tr><td class="lt"></td><td class="ct"></td><td class="rt"></td></tr>' +
            '<tr><td class="lm" valign="middle" align="center"><div class="icon"></div></td>' +
            '<td class="cm" align="center" valign="middle">' + 
            '<div class="msg" style="' + config.msgStyle + ';">'+ config.msg +'</div></td>' +
            '<td class="rm"></td></tr>' +
            '<tr><td class="lb"></td><td class="cb"></td><td class="rb"></td></tr>' +
            '</table></div>';
        
        return tpl;
    }
    return {
        /**
         * Displays a new flash message box based on the config options passed in.
         * @param {Object} config The following config options are supported: <ul>
         * <li><b>autoWidth</b> : Boolean <div class="sub-desc"> Adjust automaticaly box size (defaults true) </div></li>
         * <li><b>msg</b> : String <div class="sub-desc"> Value of the message to display in the flash box </div></li>
         * <li><b>msgStyle</b> : String <div class="sub-desc"> css style to apply into html element</div></li>
         * <li><b>pause</b> : Number<div class="sub-desc"> Number of seconds to display the flash message</div></li>
         * <li><b>type</b> : String<div class="sub-desc"> A CSS class to apply to the flash message box (e.g. warning, error, success, info or custom)</div></li>
         * <li><b>width</b> : Number<div class="sub-desc"> Width of box message</div></li>
         * </ul>
         * Example usage:
         * <pre><code>
Ext.Msg.flash({
   msg: 'The highlights fields are required!',
   pause: 3,
   type: 'error'
});        
</code></pre>
         * @return {Ext.MessageBox} this
         */
        flash : function(config){
            //Defaults config
            Ext.applyIf(config,{
               autoWidth: true,
               msg: 'Text',
               type: 'info',
               msgStyle: '',
               pause: 3,
               width: 274
            });

            //Create the flash box container
            if(!msgCt){
                msgCt = Ext.DomHelper.insertFirst(document.body, {id:'msg-div', align: 'center'}, true);
            }

            //Insert the html of flash box
            var m = Ext.DomHelper.append(msgCt, {html:createBox(config)}, true);
	    var box = Ext.get(m).select('table.box');
            
            //Register event to close flash message
            box.on('click',function(e, t){
               var f = Ext.fly(t).parent('table.' + config.type);
               f.stopFx();
               f.ghost("t",{remove: true});
            },this)

            //Animate flash message
            m.slideIn('t').pause(config.pause).ghost("t", {remove:true});

            return this;
        }
    };
}();

/**
 * Shorthand for {@link Ext.ux.MessageBox}
 */
Ext.ux.Msg = Ext.ux.MessageBox;