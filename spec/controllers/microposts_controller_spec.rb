#!/bin/env ruby
# encoding: utf-8

require "spec_helper"
include SessionsHelper

describe MicropostsController do
  
  let(:micropost) { create :micropost}
  before { sign_in(micropost.user) }

  before do
    controller.stub(:authenticate).and_return(true)
    controller.stub(:admin).and_return(true)
    controller.stub(:correct_user).and_return(true)
  end
  
  subject { controller }
  
  describe :action do
    
    describe :create do
      describe :active_filter do
        after { post :create, micropost: attributes_for(:micropost) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      describe :valid do
        before { post :create, micropost: attributes_for(:micropost) }
        it { should assign_to :micropost }
        it { should set_the_flash.to "Kurznachricht erstellt."}
        specify { response.should redirect_to root_path }
        it { expect { post :create, micropost: attributes_for(:micropost) }.to change(Micropost, :count).by(1)}
      end
      describe :invalid do
        before { post :create, micrpost: {} }
        it { should set_the_flash.to "Kurznachricht konnte nicht erstellt werden."}
        it { should render_template "static_pages/home" }
        it { expect { post :create, micropost: {} }.to change(Micropost, :count).by(0)}
      end
    end
    
    describe :destroy do
      describe :active_filter do
        after { delete :destroy, id: micropost.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { delete :destroy, id: micropost.id  }
        it { should set_the_flash.to "Kurznachricht gelöscht." }
        specify { response.should redirect_to root_path }
        it { expect { @micropost = create :micropost; delete :destroy, id: @micropost.id  }.to change(Micropost, :count).by(0)}
      end
      describe :invalid do
        before do
          Micropost.any_instance.stub(:destroy).and_return(false)
          delete :destroy, id: micropost.id 
        end
        it { should set_the_flash.to "Kurznachricht konnte nicht gelöscht werden." }
        specify { response.should redirect_to root_path }
        it { expect { delete :destroy, id: micropost.id  }.to change(Micropost, :count).by(0)}
      end
    end
  end
end