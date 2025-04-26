module DashboardHelper
  def sidebar_menu_items
    return [] unless current_user

    if current_user.has_role?(:superadmin) || current_user.has_role?(:tenant_admin)
      tenant_admin_sidebar
    elsif current_user.has_role?(:coach)
      coach_sidebar
    elsif current_user.has_role?(:player)
      player_sidebar
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

  private

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