require File.expand_path('../../test_helper', __FILE__)

class RisksControllerTest < ActionController::TestCase
  fixtures :projects, :risks

  def setup
    @project = projects(:projects_001)
    @risk    = risks(:risks_001)
  end

  test 'should get index' do
    @project.risks << @risk

    get :index, { project_id: @project }
    assert_template :index
    assert_not_nil assigns(:risks)
    assert_select 'table.risks' do
      assert_select 'td.title', @risk.title
    end
  end

  test 'should get new' do
    get :new, { project_id: @project }
    assert_template :new
    assert_not_nil assigns(:risk)
  end

  test 'should get edit' do
    get :edit, { project_id: @project, id: @risk }
    assert_template :edit
    assert_not_nil assigns(:risk)
    assert_equal @risk, assigns(:risk)
    assert_select 'input#risk_title[value=?]', @risk.title
  end

  test 'should get show' do
    get :show, { project_id: @project, id: @risk }
    assert_template :show
    assert_not_nil assigns(:risk)
    assert_equal @risk, assigns(:risk)
    assert_select 'h3', text: @risk.title
  end

  test 'should post create' do
    assert_difference 'Risk.count' do
      post :create, {
        project_id: @project,
        risk: { title: 'Risk testing', description: 'Risk testing description', probability: 2, impact: 4 }
      }
    end
    assert_redirected_to [@project, Risk.last]
  end

  test 'should put update' do
    put :update, {
      project_id: @project, id: @risk,
      risk: { title: 'Risk testing updated', description: 'Risk testing description updated', probability: 3, impact: 2 }
    }
    assert_redirected_to [@project, @risk]
  end

  test 'should destroy' do
    assert_difference 'Risk.count', -1 do
      delete :destroy, { project_id: @project, id: @risk }
      assert_redirected_to project_risks_path(@project)
    end
  end

  test 'should get index as json' do
    get :index, params: { project_id: @project, format: 'json' }
    assert_response :success
    assert_equal 'application/json', response.media_type
    json = JSON.parse(response.body)
    assert json.key?('risks')
    assert json.key?('total_count')
  end

  test 'should get show as json' do
    get :show, params: { id: @risk.id, format: 'json' }
    assert_response :success
    assert_equal 'application/json', response.media_type
    json = JSON.parse(response.body)
    assert json.key?('risk')
    assert_equal @risk.id, json['risk']['id']
    assert_equal @risk.title, json['risk']['title']
  end

  test 'should post create as json' do
    assert_difference 'Risk.count' do
      post :create, params: {
        project_id: @project,
        risk: { title: 'API Risk', description: 'API description', probability: 2, impact: 3 },
        format: 'json'
      }
    end
    assert_response :created
    assert_equal 'application/json', response.media_type
    json = JSON.parse(response.body)
    assert json.key?('risk')
    assert_equal 'API Risk', json['risk']['title']
  end

  test 'should put update as json' do
    put :update, params: {
      id: @risk.id,
      risk: { title: 'API Risk Updated' },
      format: 'json'
    }
    assert_response :no_content
    assert_equal 'API Risk Updated', @risk.reload.title
  end

  test 'should delete destroy as json' do
    assert_difference 'Risk.count', -1 do
      delete :destroy, params: { id: @risk.id, format: 'json' }
    end
    assert_response :no_content
  end
end