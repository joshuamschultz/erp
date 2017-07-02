
$(".pages.po_header").ready ->

    $('#reveal-if-direct').hide()

    $('#form_for_po_header input').on 'change', ->
        if $('input[name="po_header[po_type_id]"]:checked', '#form_for_po_header').val() == "10"
            $('#reveal-if-direct').show()
        else
            $('#reveal-if-direct').hide()
        return

$(document).ready ->
    $('#po_header_organization_id').keydown (e) ->
        code = e.keyCode or e.which
        if code == 13
            $('#po_header_organization_id').on 'change', ->
                if $('#organization_id').val() != ''
                    initialize_api_call {
                        'url': '/organizations/' + $('#organization_id').val() + '/organization_info'
                        'type': 'GET'
                        'params': {}
                    }, 'set_vendor_info', {}
                else
                    ui_id = $(this).autocomplete('widget').attr('id')
                    $('#po_header_organization_id').val $('#' + ui_id + ' li a').first().html()
                    initialize_api_call {
                        'url': '/common_actions/get_info'
                        'type': 'GET'
                        'data_type': 'json'
                        'params':
                            'mode': 'get_org'
                            'so_value': $('#po_header_organization_id').val()
                    }, 'get_org_id', {}
                return
        if code == 9
            ui_id = $(this).autocomplete('widget').attr('id')
            $('#po_header_organization_id').val $('#' + ui_id + ' li a').first().html()
            initialize_api_call {
                'url': '/common_actions/get_info'
                'type': 'GET'
                'data_type': 'json'
                'params':
                    'mode': 'get_org'
                    'so_value': $('#po_header_organization_id').val()
            }, 'get_org_id', {}
        return
    return
