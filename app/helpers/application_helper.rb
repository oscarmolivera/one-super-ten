module ApplicationHelper

  def sidebar_menu_items
    return [] unless current_user

    if current_user.has_role?(:superadmin) || current_user.has_role?(:tenant_admin)
      tenant_admin_sidebar
    elsif current_user.has_role?(:staff_assistant)
      staff_assistant_sidebar
    elsif current_user.has_role?(:coach)
      coach_sidebar
    elsif current_user.has_role?(:player)
      player_sidebar
    elsif current_user.has_role?(:team_assistant)
      team_assistant_sidebar
    else
      []
    end
  end

  def dynamic_background_style
    tenant = ActsAsTenant.current_tenant
    return default_background_style unless tenant

    gradient = case tenant.subdomain
    when 'academia-margarita'
      "linear-gradient(rgba(27,36,189,255), rgba(250,214,4,255) )"
    when 'deportivo-margarita'
      "linear-gradient(rgba(193,241,0,255), rgba(3,130,245,255))"
    when 'campeones'
      "linear-gradient(rgba(0,80,0,0.6), rgba(0,80,0,0.6))"
    else
      "linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5))"
    end

    "background-image: #{gradient}, url(#{asset_path('vendor/bg-2.jpg')}); background-size: cover; background-position: center; background-attachment: fixed;"
  end

  private

  def default_background_style
    "background-image: linear-gradient(rgba(0,199,144,255), rgba(29,108,229,255)), url(#{asset_path('vendor/bg-2.jpg')}); background-size: cover; background-position: center; background-attachment: fixed;"
  end

  def superadmin_sidebar
    [
      {
        header: "ADMINISTRACIÓN",
        items: [
          {
            label: "Dashboard Admin",
            icon: "icon-Layout-4-blocks",
            path: superadmin_root_path,
            children: []
          },
          {
            label: "Tenants",
            icon: "icon-Layout-grid",
            path: admin_tenants_path,
            children: []
          },
          {
            label: "Users",
            icon: "icon-Layout-grid",
            path: admin_users_path,
            children: []
          }
        ]
      }
    ]
  end

  def tenant_admin_sidebar
    [
      {
        header: "SYSTEM TEST",
        items: [
          {
            label: "Modelos",
            icon: "icon-Layout-grid",
            children: [
              { label: "Dashboard", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Escuelas", icon: "icon-Commit", path: schools_path },
              { label: "Categorías", icon: "icon-Commit", path: categories_path },
              { label: "Jugadores", icon: "icon-Commit", path: players_path },
            ]  
          }
        ]
      },
      {
        header: "ACADEMIA",
        items: [
          {
            label: "Categorías",
            icon: "icon-Layout-grid",
            children: [
              { label: "Listado de Categorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado de Refuerzo por categorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Informacion de Entrenadores, Delegados & Asistentes x Categorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado Jugadores x Categoria", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Torneos",
            icon: "icon-Layout-grid",
            children: [ #Menu multiplicado por las categorias existentes en la academia
              { label: "Listado Torneos Activos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "listado historial torneos del pasado", icon: "icon-Commit", path: tenant_dashboard_path },              
              { label: "Creacion de Torneos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Creacion de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Calendario de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Ingreso de data de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Actas & Protestas de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Resultados de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Tablas de Posiciones", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Convocatorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "InformacionGeneral Reglas&Grupos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Publicaciones para Padres", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Planillas de torneo para imprimir", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Entrenamientos",
            icon: "icon-Layout-grid",
            children: [#Menu multiplicado por las categorias existentes de la academia
              { label: "Horarios", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Sedes", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Federación",
            icon: "icon-Layout-grid",
            children: [# Para ser llenado por luis sobre necesidades de la federacion
              { label: "Opcion 1", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          }
        ]
      },
      {
        header: "ADMINISTRACIÓN",
        items: [
          {
            label: "Finanzas",
            icon: "icon-Layout-grid",
            children: [
              { label: "Inscribir o retirar un niño en la academia con o sin pagos especiales", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "listado de todos los inscritos en la academia ordenado por categorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Area de control de pagos y morosidad por niños por categoria", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado de Niños con mesualidad exonerada por mes o por temporada", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Inscripcion manual de pago de mansualidades/inscripcion(genera comprobante imprime y envia a correo)", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Reporte/estadistica mensual de pagos y morosidad de la academia )", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Servicios y Gastos de Funcionamiento", icon: "icon-Commit", path: tenant_dashboard_path },

            ]  
          },
          {
            label: "Personal",
            icon: "icon-Layout-grid",
            children: [
              { label: "Inscribir o dar de baja a un empleado (entrenador/asistente/delegado/otro)", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado de Personal x area y x categoria con acceso al perfil del empleado)", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Asistencia del personal y horario y sede donde el profe deberia estar dando clases )", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Tienda Online",
            icon: "icon-Layout-grid",
            children: [
              { label: "Ingreso / Egreso de productos x primera", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Cargas productos al inventario", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Ordenes de ventas de productos q genera comprobante de pago", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Sponsors",
            icon: "icon-Layout-grid",
            children: [
              { label: "Ingreso / Egreso de sponsors", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Registro de Aportes", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          }          
        ]
      },
    ]
  end

  def coach_sidebar
    [
      {
        header: "ACADEMIA",
        items: [
          {
            label: "Mis Categorías",
            icon: "icon-Layout-grid",
            children: [
              { label: "Listado de Categorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado de Refuerzo por categorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Informacion de Delegados & Asistentes x Categorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado Jugadores x Categoria", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Torneos",
            icon: "icon-Layout-grid",
            children: [ #Menu multiplicado por las categorias que tenga el entrenador asignado
              { label: "Listado Torneos Activos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "listado historial torneos del pasado", icon: "icon-Commit", path: tenant_dashboard_path },              
              { label: "Creacion de Torneos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Creacion de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Calendario de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Ingreso de data de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Actas & Protestas de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Resultados de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Tablas de Posiciones", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Convocatorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "InformacionGeneral Reglas&Grupos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Publicaciones para Padres", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Planillas de torneo para imprimir", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Entrenamientos",
            icon: "icon-Layout-grid",
            children: [#Menu multiplicado por las categorias que tenga el entrenador asignado
              { label: "Horarios", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Sedes", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          }
        ]
      }
    ]
  end

  def staff_assistant_sidebar
    [ 
      {
        header: "ADMINISTRACIÓN",
        items: [
          {
            label: "Finanzas",
            icon: "icon-Layout-grid",
            children: [
              { label: "Inscribir o retirar un niño en la academia con o sin pagos especiales", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "listado de todos los inscritos en la academia ordenado por categorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Area de control de pagos y morosidad por niños por categoria", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado de Niños con mesualidad exonerada por mes o por temporada", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Inscripcion manual de pago de mansualidades/inscripcion(genera comprobante imprime y envia a correo)", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Reporte/estadistica mensual de pagos y morosidad de la academia )", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Servicios y Gastos de Funcionamiento", icon: "icon-Commit", path: tenant_dashboard_path },

            ]  
          },
          {
            label: "Personal",
            icon: "icon-Layout-grid",
            children: [
              { label: "Inscribir o dar de baja a un empleado (entrenador/asistente/delegado/otro)", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado de Personal x area y x categoria con acceso al perfil del empleado)", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Asistencia del personal y horario y sede donde el profe deberia estar dando clases )", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Tienda Online",
            icon: "icon-Layout-grid",
            children: [
              { label: "Ingreso / Egreso de productos x primera", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Cargas productos al inventario", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Ordenes de ventas de productos q genera comprobante de pago", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Sponsors",
            icon: "icon-Layout-grid",
            children: [
              { label: "Ingreso / Egreso de sponsors", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Registro de Aportes", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          }          
        ]
      }
    ]
  end

  def team_assistant_sidebar
    [
      {
        header: "ACADEMIA",
        items: [
          {
            label: "Mi Categoría",
            icon: "icon-Layout-grid",
            children: [
              { label: "Listado Jugadores", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Listado Refuerzo", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Entrenadores Y Asistentes", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Torneos",
            icon: "icon-Layout-grid",
            children: [
              { label: "Listado Torneos Activo", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "listado historial torneos del pasado", icon: "icon-Commit", path: tenant_dashboard_path },              
              { label: "Creacion de Torneos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Creacion de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Calendario de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Ingreso de data de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Actas & Protestas de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Resultados de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Tablas de Posiciones", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Convocatorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "InformacionGeneral Reglas&Grupos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Publicaciones para Padres", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Planillas de torneo para imprimir", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Entrenamientos",
            icon: "icon-Layout-grid",
            children: [
              { label: "Horarios", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Sedes", icon: "icon-Commit", path: tenant_dashboard_path },
          
            ]
          }
        ]
      }
    ]
  end

  def player_sidebar
    [
      {
        header: "JUGADOR",
        items: [
          {
            label: "Gestion",
            icon: "icon-Library",
            children: [
              { label: "Perfil", icon: "icon-Commit", path: "#" },
              { label: "Mi Categoría (listado con perfil publico de jugadores con informacion delegado y entrenadores)", icon: "icon-Commit", path: "#" },
              { label: "Palmarés en perfil", icon: "icon-Commit", path: "#" },
              { label: "Album de fotos en perfil", icon: "icon-Commit", path: "#" },
            ]
          },
          {
            label: "Torneos",
            icon: "icon-Layout-grid",
            children: [
              { label: "solo ver listado Torneos Activo", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "solo ver listado historial torneos del pasado", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "solo ver Calendario de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "solo ver Resultados de Partidos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "solo ver Tablas de Posiciones", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "solo ver Convocatorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "solo ver InformacionGeneral Reglas&Grupos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "solo ver Publicaciones para Padres", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "solo ver Relacion del Pote del Albitraje", icon: "icon-Commit", path: tenant_dashboard_path },
            ]
          },
          {
            label: "Entrenamientos",
            icon: "icon-Layout-grid",
            children: [
              { label: "Horarios", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Sedes", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          },
          {
            label: "Mensualidad",
            icon: "icon-Layout-grid",
            children: [
              { label: "Historial de Relacion de Pagos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Comprobante de  Pagos con impresion", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Reporte de Pagos", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          }          
        ]
      }
    ]
  end
end
