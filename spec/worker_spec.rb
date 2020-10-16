RSpec.describe ActiveAdmin::AsyncExporter::Worker do
  let!(:users) do
    %w[user_1 user_2 user_3].map do |username|
      User.find_or_create_by!(username: username)
    end
  end
  let(:controller) { Admin::UsersController.new }
  let(:decorate_model) { false }
  let(:file_name) { 'file_name' }
  let(:query) { nil }
  let(:csv_path) { './csv' }
  let(:admin) { User.find_or_create_by!(username: 'AdminUser') }
  let(:csv_fixture_file_path) { "./spec/fixtures/files/#{csv_fixture_file_name}.csv" }
  let(:csv_fixture_file_name) { 'username' }

  let(:admin_report) do
    AdminReport.create!(author_id: admin.id,
                        entity: User.name,
                        status: :pending)
  end

  let(:columns) { { username: { block: false, value: 'username' } } }

  let(:options) do
    {
      admin_report_id: admin_report.id,
      controller: controller.class.name,
      columns: columns,
      decorate_model: decorate_model,
      file_name: file_name,
      query: query
    }
  end

  subject do
    described_class.perform_now(options)
  end

  context 'with valid options' do
    let(:test_date) { Time.current }
    let(:full_file_name) { [file_name, test_date.to_i].join('_') + '.csv' }
    let(:file_path) { "#{csv_path}/#{full_file_name}" }

    before do
      travel_to(test_date)
    end

    after do
      FileUtils.rm(file_path)
      travel_back
    end

    shared_examples 'creates the physical file with data' do
      it 'creates the physical file at the given location_url' do
        subject
        expect(File.open(admin_report.reload.location_url)).to be
      end

      it 'physical path is the expected' do
        subject
        expect(admin_report.reload.location_url).to eq(file_path)
      end

      it 'physical file contains data' do
        subject
        expect(File.open(admin_report.reload.location_url).read).to be
      end

      it 'generated csv file contains the expected results' do
        subject

        generated_file_data = File.open(admin_report.reload.location_url).read

        expect(File.open(csv_fixture_file_path).read).to eq(generated_file_data)
      end
    end

    it 'changes admin_report status to ready' do
      expect { subject }.to change { admin_report.reload.status }.from('pending').to('ready')
    end

    it 'changes admin_report location_url' do
      expect { subject }.to change { admin_report.reload.location_url }
    end

    context 'when the file_name is given' do
      it 'full file name is the correct file name' do
        subject
        expect(admin_report.reload.location_url.split('/').last).to eq(full_file_name)
      end

      it_behaves_like 'creates the physical file with data'
    end

    context 'when the file_name is not given' do
      let(:file_name) { nil }
      let(:full_file_name) do
        [controller.current_collection.name.pluralize.downcase, test_date.to_i].join('_') + '.csv'
      end

      it 'full file name is the correct file name' do
        subject
        expect(admin_report.reload.location_url.split('/').last).to eq(full_file_name)
      end

      it_behaves_like 'creates the physical file with data'
    end

    context 'when the column is an attribute' do
      it_behaves_like 'creates the physical file with data'
    end

    context 'when the column is a block' do
      let(:block) do
        proc { |user| "The username is: #{user.username}" }
      end
      let(:csv_fixture_file_name) { 'block' }
      let(:columns) { { test_block: { block: true, value: block.source } } }

      it_behaves_like 'creates the physical file with data'
    end

    context 'when we have multiple columns' do
      let(:block) do
        proc { |user| "The username is: #{user.username}" }
      end

      let(:csv_fixture_file_name) { 'username_and_block' }
      let(:columns) do
        {
          username: { block: false, value: 'username' },
          test_block: { block: true, value: block.source }
        }
      end

      it_behaves_like 'creates the physical file with data'
    end
  end
end
