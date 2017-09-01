ActiveAdmin.register Zone do
  permit_params :name

  controller do
    def destroy
      destroy! do |_success, failure|
        failure.html do
          flash[:error] = 'La acción falló: ' + resource.errors.full_messages.to_sentence
          render action: :index
        end
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  show do # |zone|
    attributes_table do
      row :name
    end
  end

  form do |f|
    f.inputs 'Zone Details', allow_destroy: true do
      f.semantic_errors(*f.object.errors.keys)
      f.input :name
    end
    f.actions
  end
end
