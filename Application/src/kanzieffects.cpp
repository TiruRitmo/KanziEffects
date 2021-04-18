// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <kanzi/kanzi.hpp>

using namespace kanzi;

class KanziEffects : public ExampleApplication
{
public:

    virtual void onConfigure(ApplicationProperties& configuration) KZ_OVERRIDE
    {
        configuration.binaryName = "kanzieffects.kzb.cfg";
    }

    virtual void onProjectLoaded() KZ_OVERRIDE
    {
        // Project file has been loaded from .kzb file.

        // Add initialization code here.
    }
};

Application* createApplication()
{
    return new KanziEffects;
}
