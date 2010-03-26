<%inherit file="/base.mako"/>
<%namespace file="/root/history_common.mako" import="render_dataset" />

<%def name="stylesheets()">
    ${parent.stylesheets()}
    ${h.css( "history" )}
    <style type="text/css">
        body {
            background: white;
            padding: 5px;
        }
        
        .clickable {
            cursor: pointer;
        }
        
        .workflow {
            border: solid gray 1px;
            border-left-width: 5px;
        }
        
        .workflow > .header {
            background: lightgray;
            padding: 5px 10px;
            
            font-weight: bold;
        }
        
        .workflow > .body {
            border-top: solid gray 1px;
            padding: 5px;
        }
        
        div.toolForm {
            margin: 5px 0;
            border-left-width: 5px;
        }
        div.toolFormBody {
            padding: 5px 5px;
        }
    </style>
</%def>

<%def name="javascripts()">
    ${parent.javascripts()}
    <script type="text/javascript">
        $(function(){
            
            $(".workflow, .tool").each( function() {
                var body = $(this).children( ".body" );
                $(this).children( ".header" ).click( function() {
                    body.toggle();
                }).addClass( "clickable" );
                // body.hide();
            });
            
            $(".historyItem").each( function() {
                var id = this.id;
                var body = $(this).children( "div.historyItemBody" );
                var peek = body.find( "pre.peek" )
                $(this).children( ".historyItemTitleBar" ).find( ".historyItemTitle" ).wrap( "<a href='#'></a>" ).click( function() {
                    if ( body.is(":visible") ) {
                        // Hiding stuff here
                        if ( $.browser.mozilla ) { peek.css( "overflow", "hidden" ) }
                        body.slideUp( "fast" );
                    } else {
                        // Showing stuff here
                        body.slideDown( "fast", function() { 
                            if ( $.browser.mozilla ) { peek.css( "overflow", "auto" ); } 
                        });
                    }
                    return false;
                });
                body.hide();
            });
        });    
    </script>
</%def>

<%def name="render_item( entity, children )">
<%
entity_name = entity.__class__.__name__
if entity_name == "HistoryDatasetAssociation":
    render_item_hda( entity, children )
elif entity_name == "Job":
    render_item_job( entity, children )
elif entity_name == "WorkflowInvocation":
    render_item_wf( entity, children )
%>
</%def>

<%def name="render_item_hda( hda, children  )">
    ${render_dataset( hda, hda.hid )}
</%def>

<%def name="render_item_job( job, children  )">

    <div class="tool toolForm">
        <div class="header toolFormTitle">Tool: ${trans.app.toolbox.tools_by_id[job.tool_id].name}</div>
        <div class="body toolFormBody">
        %for e, c in children:
            ${render_item( e, c )}
        %endfor
        </div>
    </div>

</%def>

<%def name="render_item_wf( wf, children )">

    <div class="workflow">
        <div class="header">Workflow: ${wf.workflow.name}</div>
        <div class="body">
        %for e, c in children:
            ${render_item( e, c )}
        %endfor
        </div>
    </div>

</%def>

%for entity, children in items:
    ${render_item( entity, children )}
%endfor