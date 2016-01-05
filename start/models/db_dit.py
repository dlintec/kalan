# -*- coding: utf-8 -*-
def breadcrumbs(arg_title=None):
    "Create breadcrumb links for current request"
    # make links pretty by capitalizing and using 'home' instead of 'default'
    pretty = lambda s: s.replace('SG_control', response.title).replace('default', 'Início').replace('_', ' ').capitalize()
    menus = [A(T('Home'), _href=URL(r=request, c='default', f='index'))]
    if request.controller != 'default':
        # add link to current controller
        menus.append(A(T(pretty(request.controller)), _href=URL(r=request, c=request.controller, f='index')))
        if request.function == 'index':
            # are at root of controller
            menus[-1] = A(T(pretty(request.controller)), _href=URL(r=request, c=request.controller, f=request.function))
        else:
            # are at function within controller
            menus.append(A(T(pretty(request.function)), _href=URL(r=request, c=request.controller, f=request.function)))
        # you can set a title putting using breadcrumbs('My Detail Title') 
        if request.args and arg_title:
            menus.append(A(T(arg_title)), _href=URL(r=request, c=request.controller, f=request.function,args=[request.args]))
    else:
        #menus.append(A(pretty(request.controller), _href=URL(r=request, c=request.controller, f='index')))
        if request.function == 'index':
            # are at root of controller
            #menus[-1] = pretty(request.controller)
            pass
            #menus.append(A(pretty(request.controller), _href=URL(r=request, c=request.controller, f=request.function)))
        else:
            # are at function within controller
            menus.append(A(T(pretty(request.function)), _href=URL(r=request, c=request.controller, f=request.function)))
        # you can set a title putting using breadcrumbs('My Detail Title') 
        if request.args and arg_title:
            menus.append(A(T(arg_title), _href=URL(r=request, f=request.function,args=[request.args])))

    return XML(' > '.join(str(m) for m in menus))

def dic_lista(lista):
	for i in range(len(lista)):
		for key in lista[i]:
			try:
				lista[i][key] = lista[i][key].decode('utf8')
			except:
				lista[i][key] = lista[i][key]
	return lista
