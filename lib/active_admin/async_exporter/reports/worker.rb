# frozen_string_literal: true

module ActiveAdmin
  module AsyncExporter
    class Worker
      include Sidekiq::Worker

      def perform(options = {})
        controller = options['controller'].classify.constantize.new
        columns = options['columns']

        path = Rails.root.join('tmp', filename(controller))

        CSV.open(path, 'wb', headers: true) do |csv|
          build_csv(csv, columns, controller, options)
        end

        AdminReport.find(options['admin_report_id']).update_attributes(status: :ready)
      end

      private

      def collection(controller, options)
        controller.current_collection.ransack(options['query']).result
      end

      def filename(controller)
        [controller.current_collection.name.pluralize.downcase, Time.current.to_i].join('_') + '.csv'
      end

      def build_csv(csv, columns, controller, options)
        headers = columns.keys
        evaluators = columns.values

        csv << headers.map(&:to_s)

        collection(controller, options).find_in_batches do |group|
          group.each do |m|
            m = m.decorate if options['decorate_model']

            csv << evaluators.collect { |ev| m.send(ev) }
          end
        end
      end
    end
  end
end
