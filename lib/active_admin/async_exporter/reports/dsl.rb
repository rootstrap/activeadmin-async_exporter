# frozen_string_literal: true

module ActiveAdmin
  module AsyncExporter
    module Reports
      module DSL
        def csv_report(columns:, decorate_model: false)
          action_item :download_csv, only: :index do
            link_to 'Download CSV',
                    { action: :download_csv, params: params.to_enum.to_h },
                    method: :post, data: { confirm: 'Are you sure you want to generate this report?' }
          end

          collection_action :download_csv, method: :post do
            admin_report = AdminReport.create!(
              author_id: current_admin_user.id,
              entity: current_collection.name,
              status: :pending
            )

            options = {
              admin_report_id: admin_report.id,
              controller: self.class.name,
              columns: columns,
              decorate_model: decorate_model,
              query: params['q']
            }

            ActiveAdmin::AsyncExporter::Worker.perform_async(options)
            redirect_to admin_admin_report_path(admin_report)
          end

          controller do
            def current_collection
              scoped_collection
            end
          end
        end
      end
    end
  end
end
