# -*- coding: utf-8 -*-
"""db_SG2 = DAL('sqlite://db_SG.db',
    pool_size=0,
    folder=None,
    db_codec='UTF-8',
    check_reserved=None,
    migrate=True,
    fake_migrate=False,
    migrate_enabled=True,
    fake_migrate_all=False,
    decode_credentials=False,
    driver_args=None,
    adapter_args=None,
    attempts=5,
    auto_import=False,
    bigint_id=False,
    debug=False,
    lazy_tables=True,
    db_uid=None,
    do_connect=True,
    after_connection=None,
    tables=None,
    ignore_field_case=True,
    entity_quoting=False,
    table_hash=None
    )
"""
db_SG=db
response.no_cssmenu=True
response.subtitle=''
from plugin_ckeditor import CKEditor

ckeditor = CKEditor(db)
ckeditor.define_tables()



def widget_contenidoHTML(field, value):
    jqeditor=ckeditor.widget
    return jqeditor

db_SG.define_table('ESTANDARES',
     Field('FECHA',type='date',widget=SQLFORM.widgets.date.widget,requires=IS_DATE()),
     Field('VIGENTE',type='boolean',default=True,label=T('Vigente')),
     Field('TITULO',required=True, notnull=True,unique=True,label='Titulo'),
     Field('CONTENIDO',type='text',widget=ckeditor.widget),
     #Field('CONTENIDO',type='blob',widget=lambda r,v: widget_contenidoHTML(r,v)),
     #Field('CONTENIDO',type='text',widget=SQLFORM.widgets.text.widget,readable=False),
     Field('CREADO', 'datetime', default=request.now,writable=False), 
     Field('CREADO_POR', db.auth_user, default=auth.user_id,writable=False), 
     Field('MODIF', 'datetime', update=request.now,writable=False), 
     Field('MODIF_POR', db.auth_user, update=auth.user_id,writable=False), 
     format = '%(TITULO)s' 
    )
db_SG.define_table('DOMINIOS',
     Field('ID_ESTANDAR','reference ESTANDARES',requires=IS_IN_DB(db_SG(db_SG.ESTANDARES.id>0), 'ESTANDARES.id', 'ESTANDARES.TITULO')),
     Field('INDICE',required=True, notnull=True,unique=True),
     Field('TITULO',required=True, notnull=True,unique=True,label='Titulo'),
     Field('CONTENIDO',type='text',widget=ckeditor.widget),
     Field('CREADO', 'datetime', default=request.now,writable=False), 
     Field('CREADO_POR', db.auth_user, default=auth.user_id,writable=False), 
     Field('MODIF', 'datetime', update=request.now,writable=False), 
     Field('MODIF_POR', db.auth_user, update=auth.user_id,writable=False), 
     format = '%(TITULO)s'
    )
db_SG.define_table('OBJETIVOS',
     Field('ID_DOMINIO','reference DOMINIOS',requires=IS_IN_DB(db_SG(db_SG.DOMINIOS.id>0), 'DOMINIOS.id', 'DOMINIOS.TITULO')),
     Field('INDICE',required=True, notnull=True,unique=True),
     Field('TITULO',required=True, notnull=True,unique=True,label='Titulo'),
     Field('CONTENIDO',type='text',widget=ckeditor.widget),
     Field('CREADO', 'datetime', default=request.now,writable=False), 
     Field('CREADO_POR', db.auth_user, default=auth.user_id,writable=False), 
     Field('MODIF', 'datetime', update=request.now,writable=False), 
     Field('MODIF_POR', db.auth_user, update=auth.user_id,writable=False), 
     format = '%(TITULO)s'
    )
db_SG.define_table('CONTROLES',
     Field('ID_OBJETIVO','reference OBJETIVOS',requires=IS_IN_DB(db_SG(db_SG.OBJETIVOS.id>0), 'OBJETIVOS.id', 'OBJETIVOS.TITULO')),
     Field('INDICE',required=True, notnull=True,unique=True),
     Field('TITULO',required=True),
     Field('CONTENIDO',type='text',widget=ckeditor.widget),
     Field('CREADO', 'datetime', default=request.now,writable=False), 
     Field('CREADO_POR', db.auth_user, default=auth.user_id,writable=False), 
     Field('MODIF', 'datetime', update=request.now,writable=False), 
     Field('MODIF_POR', db.auth_user, update=auth.user_id,writable=False), 
     format = '%(TITULO)s'
    )
db_SG.define_table('POLITICAS',
     Field('ID_CONTROL','reference CONTROLES',requires=IS_IN_DB(db_SG(db_SG.CONTROLES.id>0), 'CONTROLES.id', 'CONTROLES.TITULO')),
     Field('INDICE',required=True, notnull=True,unique=True),
     Field('TITULO',required=True, notnull=True,unique=True,label='Titulo'),
     Field('CONTENIDO',type='text',widget=ckeditor.widget),
     Field('CREADO', 'datetime', default=request.now,writable=False), 
     Field('CREADO_POR', db.auth_user, default=auth.user_id,writable=False), 
     Field('MODIF', 'datetime', update=request.now,writable=False), 
     Field('MODIF_POR', db.auth_user, update=auth.user_id,writable=False), 
     format = '%(TITULO)s'
    )
