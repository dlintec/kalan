# -*- coding: utf-8 -*-
@auth.requires_membership(role='admin') # uncomment to enable security 
def dit_lista_usuarios():
    contenedor=DIV()
    botones=dit_barraBotones()
    contenedor.append(botones)

    if 'nuevo'==request.args(0):
        response.title='Crear Usuario'
        contenedor.append(SQLFORM(db.auth_user, _class='form-horizontal').process())
    else:
        response.title='Usuarios'
        btn = lambda row: A("Edit", _href=URL('dit_usuarios', args=row.auth_user.id))
        db.auth_user.edit = Field.Virtual(btn)
        rows = db(db.auth_user).select()
        headers = ["ID", T("Name"), T("Last Name"), T("Email"), T("Edit")]
        fields = ['id', 'first_name', 'last_name', "email", "edit"]
        botones.append(A(IMG(_src=URL("static","dit/img/flat_ico/32/add199.png")),_href=URL()+"/nuevo",_title='Agregar nuevo'))
        table = TABLE(THEAD(TR(*[B(header) for header in headers])),
                      TBODY(*[TR(*[TD(row[field]) for field in fields]) for row in rows]))
        table["_class"] = "table table-striped table-bordered table-condensed"
        contenedor.append(table)
    return dict(form=contenedor)

@auth.requires_membership(role='admin') # uncomment to enable security 
def dit_usuarios():
    contenedor=DIV()
    botones=dit_barraBotones()
    contenedor.append(botones)

    user_id = request.args(0) or redirect(URL('dit_lista_usuarios'))
    form = SQLFORM(db.auth_user, user_id).process()
    contenedor.append(form)
    membership_panel = LOAD(request.controller,
                            'dit_editar_membresias.html',
                             args=[user_id],
                             ajax=True)
    return dict(form=contenedor,membership_panel=membership_panel)

@auth.requires_membership(role='admin') # uncomment to enable security
def dit_editar_membresias():
    user_id = request.args(0) or redirect(URL('dit_lista_usuarios'))
    db.auth_membership.user_id.default = int(user_id)
    db.auth_membership.user_id.writable = False
    form = SQLFORM.grid(db.auth_membership.user_id == user_id,
                       args=[user_id],
                       searchable=False,
                       deletable=False,
                       details=False,
                       selectable=False,
                       csv=False,
                       user_signature=False)
    return form

def SG_inicio():
    import simplejson as json
    opciones = json.loads(request.post_vars.opciones)
    objetoRespuesta={}
    objetoRespuesta['ESTANDARES']=db_SG().select(db_SG.ESTANDARES.id,db_SG.ESTANDARES.TITULO).as_list()
    objetoRespuesta['DOMINIOS']=db_SG().select(db_SG.DOMINIOS.id,db_SG.DOMINIOS.TITULO,db_SG.DOMINIOS.ID_ESTANDAR).as_list()
    objetoRespuesta['OBJETIVOS']=db_SG().select(db_SG.OBJETIVOS.id,db_SG.OBJETIVOS.TITULO,db_SG.OBJETIVOS.ID_DOMINIO).as_list()
    objetoRespuesta['CONTROLES']=db_SG().select(db_SG.CONTROLES.id,db_SG.CONTROLES.TITULO,db_SG.CONTROLES.ID_OBJETIVO).as_list()
    objetoRespuesta['POLITICAS']=db_SG().select(db_SG.POLITICAS.id,db_SG.POLITICAS.TITULO,db_SG.POLITICAS.ID_CONTROL).as_list()
    return json.JSONEncoder().encode(objetoRespuesta)

def dit_imagenLiga(URLimagen,URLpliga,ptitulo=response.title):
    return A(IMG(_src=URLimagen),_href=URLpliga,_title=ptitulo,_style="padding:0px 0px 0px 0px;padding-right:10px;")

def dit_barraBotones():
    botones=DIV(_style="background:#eeeeee;padding:5px 15px 5px 5px;padding-left:15px;")
    ligaAtras=dit_imagenLiga(URL("static","dit/img/web_ico/32/left177.png"),'javascript:void(history.go(-1))',T('Back'))
    botones.append(ligaAtras)
    return botones



def SG_PDF():
    return locals()
def validar_CONTENIDO(form):
    c = str(form.vars.CONTENIDO)
    todoCorrecto=True
    
    if len(c)>1024*1024:
       form.errors.CONTENIDO = 'Error en contenido muy grande. Tamaño:'+str(len(c))
    else:
       form.vars.CONTENIDO = c

tablasControl={}
tablasControl['ESTANDARES']={'titulo':'Librerias','tabla':db_SG.ESTANDARES,'validador':validar_CONTENIDO,
                             'icono':URL("static","dit/img/flat_ico/dit/certif.png"),'tablaInferior':'DOMINIOS','llave':0}
tablasControl['DOMINIOS']={'titulo':'Secciones','tabla':db_SG.DOMINIOS,'validador':validar_CONTENIDO,
                           'icono':URL("static","dit/img/flat_ico/dit/certif.png"),'tablaInferior':'OBJETIVOS','llave':'ID_ESTANDAR'}
tablasControl['OBJETIVOS']={'titulo':'Objetivos','tabla':db_SG.OBJETIVOS,'validador':validar_CONTENIDO,
                            'icono':URL("static","dit/img/flat_ico/dit/certif.png"),'tablaInferior':'CONTROLES','llave':'ID_DOMINIO'}
tablasControl['CONTROLES']={'titulo':'Controles','tabla':db_SG.CONTROLES,'validador':validar_CONTENIDO,
                            'icono':URL("static","dit/img/flat_ico/dit/certif.png"),'tablaInferior':'POLITICAS','llave':'ID_OBJETIVO'}    
tablasControl['POLITICAS']={'titulo':'Políticas','tabla':db_SG.POLITICAS,'validador':validar_CONTENIDO,
                            'icono':URL("static","dit/img/flat_ico/dit/certif.png"),'tablaInferior':0,'llave':'ID_CONTROL'}    
tablaSuperior=tablasControl['ESTANDARES']
def SG_control():
    from gluon.tools import Crud
    crud = Crud(db)
    crud.settings.formstyle=''
    botones=''
    forma=''
    response.no_cssmenu=True
    response.no_echarts=True
    response.iconURL='dit/img/flat_ico/dit/certif.png'
    contenedor=DIV(_class='container-fluid')
    proceso=request.vars['p']
    tablaURL=request.vars['t']
    if tablaURL==None:
        tablaURL='ESTANDARES'
        session.docActual = None;
    kdefault=request.vars['k']
    idd=request.vars['idd']
    agregarK=""
    if kdefault!=None:
        agregarK='&k='+kdefault
    response.forzarCKEditor=request.vars['ck']
    if response.forzarCKEditor==None:
        response.forzarCKEditor=0;
    botones=dit_barraBotones()
    divForma=DIV(_class='container')
    contenedor.append(botones)
    contenedor.append(divForma)
    #if  (tablaURL!=None and (tablaURL in tablasControl)) or proceso!=None:
    if session.docActual:
        response.title=session.docActual

    if  (tablaURL in tablasControl):
        objetoTabla=tablasControl[tablaURL]
        response.title=objetoTabla['titulo']
        response.subtitle=objetoTabla['titulo']
        if len(request.args):
            if str(request.args(0)) in 'new':
                tablaURL=request.args(1)
                if kdefault!=None:
                    llave=objetoTabla['llave']
                    db[tablaURL][llave].default=kdefault

                forma=crud.create(db[tablaURL],_class='form-horizontal')
                divForma.append(forma)
                response.title='Crear Objeto en '+objetoTabla['titulo']
                response.subtitle=objetoTabla['titulo']+'(c)'
                return dict(form=contenedor)

            idArgs=request.args(0)
            if proceso==None:
                proceso='leer'
            if tablaURL=='ESTANDARES':
                if idArgs:
                    session.idDoc = idArgs
                    doc=db_SG.ESTANDARES(db_SG.ESTANDARES.id==idArgs)
                    session.docActual=doc.TITULO
                    agregarK=agregarK+'&idd='+idArgs

            if 'leer' in proceso:
                response.title='Consulta de '+objetoTabla['titulo']
                objetoTabla['tabla'].CONTENIDO.represent = lambda r,v: XML(v.CONTENIDO)
                forma=SQLFORM(objetoTabla['tabla'],record=idArgs,readonly=True, _class='form-horizontal')
                ligaEditar=dit_imagenLiga(URL("static","dit/img/web_ico/32/pencil90.png"),URL()+"/"+idArgs+"?p=editar"+"&t="+tablaURL,'Modificar')
                #ligaEditar=A(IMG(_src=URL("static","dit/img/flat_ico/32/writing133.png")),_href=URL()+"/"+request.args(0)+"?p=editar",_title='Modificar')
                #ligaEditar.append("Modificar")


                botones.append(ligaEditar)
            else:
                response.title='Modificar '+objetoTabla['titulo']
                forma=SQLFORM(objetoTabla['tabla'],record=idArgs,deletable=True, _class='form-horizontal')
            #forma=crud.update(db_SG.ESTANDARES,record=request.args(0))


            divForma.append(forma)
            if objetoTabla['tablaInferior']!=0:
                objetoTablaInferior=tablasControl[objetoTabla['tablaInferior']]
                #tabla2 = SQLFORM.grid(objetoTablaInferior['tabla'],details=False,deletable=False,csv =False,paginate=0,fields=[objetoTablaInferior['tabla'].TITULO])
                tablaInferior=objetoTablaInferior['tabla']
                llaveInferior=objetoTablaInferior['llave']
                elQuery=tablaInferior[llaveInferior]==objetoTabla['tabla'].id
                registrosTablaInferior=db_SG(elQuery).select(objetoTablaInferior['tabla'].ALL)
               
                if 'editar' in proceso:
                    divForma.append(
                        H3( 
                            CAT( 
                                A( CAT(IMG(_src=URL("static","dit/img/flat_ico/32/doc_agregar.png")), 'Agregar' ),
                                  _href=URL()+"?p=nuevo"+"&t="+objetoTabla['tablaInferior']+"&k="+str(idArgs),_title='Agregar nuevo'), '  ',
                                objetoTablaInferior['titulo']
                            )
                        )
                    )
                else:
                    if len(registrosTablaInferior)>0:
                        divForma.append(H3(objetoTablaInferior['titulo']))

                for row in registrosTablaInferior:
                    divForma.append(H4(A(CAT(IMG(_src=objetoTablaInferior['icono']),'  ',row.INDICE,'  ',row.TITULO),_href=URL()+'/'+str(row.id)+"?t="+objetoTabla['tablaInferior'])))

        else:

            if  proceso!=None:
                strProceso=str(proceso)

                if 'nuevo' in strProceso:
                    #contenedor.append('*****nuevo****')
                    if kdefault!=None:
                        llave=objetoTabla['llave']
                        objetoTabla['tabla'][llave].default=kdefault
                    forma=SQLFORM(objetoTabla['tabla'], _class='form-horizontal')
                    response.subtitle='Agregar a '+objetoTabla['titulo']

                divForma.append(forma)
            else:
                if objetoTabla['tabla']=='ESTANDARES':
                    session.idDoc = None
                    session.docActual = None;

                #db_SG.ESTANDARES.TITULO.represent = lambda r,v: A(v.TITULO,_href=URL('SG_control')+'/'+str(v.id)+"?p=editar")
                #objetoTabla['tabla'].TITULO.represent = lambda r,v: A(v.TITULO,_href=URL()+'/'+str(v.id)+"?t="+tablaURL)
                objetoTabla['tabla'].TITULO.represent = lambda r,v: H4(A(CAT(IMG(_src=objetoTabla['icono']),'  ',v.TITULO),_href=URL()+'/'+str(v.id)+"?t="+tablaURL))


                tabla = SQLFORM.grid(objetoTabla['tabla'],details=False,editable=False,deletable=False,csv =False,paginate=0,fields=[objetoTabla['tabla'].TITULO])

                botones.append(A(IMG(_src=URL("static","dit/img/flat_ico/32/add200.png")),_href=URL()+"?p=nuevo"+"&t="+tablaURL+agregarK,_title='Agregar nuevo'))
                divForma.append(tabla)
                form=contenedor

    if forma!='':
        if forma.process(onvalidation=objetoTabla['validador']).accepted:
            session.flash = T('form accepted')
            nuevaURL=URL()+'?t='+tablaURL
            if kdefault!=None:
                nuevaURL=nuevaURL+agregarK
            redirect(nuevaURL)
        elif forma.errors:
            response.flash = T('form has errors')+':'+XML(forma.errors)
        ##else:
            ##response.flash = T('please fill the form')            
    if session.docActual:
        response.title=session.docActual
    return dict(form=contenedor)


# this file is released under public domain and you can use without limitations

#########################################################################
## This is a sample controller
## - index is the default action of any application
## - user is required for authentication and authorization
## - download is for downloading files uploaded in the db (does streaming)
#########################################################################

def index():
    response.no_cssmenu=True
    """
    example action using the internationalization operator T and flash
    rendered by views/default/index.html or views/generic.html

    if you need a simple wiki simply replace the two lines below with:
    return auth.wiki()
    """
    #response.flash = T("Welcome")
    return dict(message=T('SGSI'))


def user():
    response.no_cssmenu=True

    """
    exposes:
    http://..../[app]/default/user/login
    http://..../[app]/default/user/logout
    http://..../[app]/default/user/register
    http://..../[app]/default/user/profile
    http://..../[app]/default/user/retrieve_password
    http://..../[app]/default/user/change_password
    http://..../[app]/default/user/manage_users (requires membership in
    http://..../[app]/default/user/bulk_register
    use @auth.requires_login()
        @auth.requires_membership('group name')
        @auth.requires_permission('read','table name',record_id)
    to decorate functions that need access control
    """
    return dict(form=auth())


@cache.action()
def download():
    """
    allows downloading of uploaded files
    http://..../[app]/default/download/[filename]
    """
    return response.download(request, db)


def call():
    """
    exposes services. for example:
    http://..../[app]/default/call/jsonrpc
    decorate with @services.jsonrpc the functions to expose
    supports xml, json, xmlrpc, jsonrpc, amfrpc, rss, csv
    """
    return service()
