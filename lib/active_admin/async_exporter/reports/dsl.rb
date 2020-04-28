# frozen_string_literal: true

module ActiveAdmin
  module AsyncExporter
    module Reports
      module DSL
        attr_reader :csv_fields

        def csv_async(decorate_model: false, file_name: nil)
          @csv_fields ||= {}

          yield

          csv_report(columns: csv_fields, decorate_model: decorate_model, file_name: file_name)
        end

        def csv_column(column_name, column_value = nil)
          column_value ||= column_name

          csv_fields[column_name.to_sym] = column_value.to_s
        end

        def csv_report(columns:, decorate_model: false, file_name: nil)
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
              file_name: file_name,
              query: params['q']
            }

            ActiveAdmin::AsyncExporter::Worker.perform_later(options)
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
