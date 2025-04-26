module DashboardHelper
  def sidebar_menu_items
    return [] unless current_user

    if current_user.has_role?(:superadmin) || current_user.has_role?(:tenant_admin)
      tenant_admin_sidebar
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

  def dynamic_content_wrapper
    return 'shared/dashboard/default_dashboard' unless current_user

    partial_name = "#{current_user.role_name}_dashboard".downcase
    "shared/dashboard/#{partial_name}"
  rescue
    'shared/dashboard/default_dashboard'
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

    "background-image: #{gradient}, url('/vendor/bg-2.jpg'); background-size: cover; background-position: center; background-attachment: fixed;"
  end

  private

  def default_background_style
    "background-image: linear-gradient(rgba(0,199,144,255), rgba(29,108,229,255)), url('/vendor/bg-2.jpg'); background-size: cover; background-position: center; background-attachment: fixed;"
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
        header: "ACADEMIA",
        items: [
          {
            label: "Escuela",
            icon: "icon-Layout-4-blocks",
            children: [
              { label: "Escritorio", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Gestión", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          },
          {
            label: "Entrenamiento",
            icon: "icon-Layout-grid",
            children: [
              { label: "Cronogramas", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          },
          {
            label: "Alumnos",
            icon: "icon-Layout-grid",
            children: [
              { label: "Gestión", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          },
          {
            label: "Torneos",
            icon: "icon-Layout-grid",
            children: [
              { label: "Gestión", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Calendario", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Albitraje", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          },
          {
            label: "Categorias",
            icon: "icon-Layout-grid",
            children: [
              { label: "Gestión", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Convocatorias", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Mi Categoria", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          }
        ]
      },
      {
        header: "ADMINISTRACIÓN",
        items: [
          {
            label: "Finanzas",
            icon: "icon-Write",
            children: [
              { label: "Inscripción", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Mensualidades", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Exoneraciones", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Ingresos", icon: "icon-Commit", path: tenant_dashboard_path },
              { label: "Egresos", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          },
          {
            label: "Personal",
            icon: "icon-Write",
            children: [
              { label: "Nomina", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          },
          {
            label: "Tienda",
            icon: "icon-Chart-pie",
            children: [
              { label: "Ordenes", icon: "icon-Commit", path: "#" },
              { label: "Productos", icon: "icon-Commit", path: "#" },
              { label: "Inline charts", icon: "icon-Commit", path: "#" },
              { label: "Inventario", icon: "icon-Commit", path: "#" }
            ]
          }
        ]
      }
    ]
  end

  def coach_sidebar
    [
      {
        header: "ACADEMIA",
        items: [
          {
            label: "Entrenamientos",
            icon: "icon-Layout-grid",
            children: [
              { label: "Mi Cronograma", icon: "icon-Commit", path: tenant_dashboard_path }
            ]
          },
          {
            label: "Torneos",
            icon: "icon-Layout-grid",
            children: [
              { label: "Mis Torneos", icon: "icon-Commit", path: tenant_dashboard_path }
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
              { label: "Creacion de Torneos", icon: "icon-Commit", path: tenant_dashboard_path },
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
              { label: "Entrenamientos", icon: "icon-Commit", path: "#" },
              { label: "Palmarés", icon: "icon-Commit", path: "#" },
              { label: "Torneos", icon: "icon-Commit", path: "#" },
              { label: "Pagos", icon: "icon-Commit", path: "#" }
            ]
          }
        ]
      }
    ]
  end
end