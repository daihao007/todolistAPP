#include <js_native_api.h>
#include <js_native_api_types.h>
#include <node_api.h>
#include <hilog/log.h>

#include <algorithm>
#include <string>
#include <vector>

std::vector<std::string> ExtractKeywordsNative(const std::string& text, int topK);
std::vector<std::string> ScoreSentencesNative(
    const std::string& text,
    const std::vector<std::string>& keywords,
    int topK);
std::string HashPasswordNative(const std::string& password, const std::string& salt);
std::string GenerateSaltNative();
bool VerifyPasswordNative(const std::string& password, const std::string& salt, const std::string& expectedHash);

namespace {

constexpr unsigned int TEXT_ANALYZER_LOG_DOMAIN = 0x0001;
constexpr const char* TEXT_ANALYZER_LOG_TAG = "TextAnalyzer";

napi_value CreateStringArray(napi_env env, const std::vector<std::string>& values)
{
    napi_value array;
    napi_create_array_with_length(env, values.size(), &array);
    for (size_t i = 0; i < values.size(); ++i) {
        napi_value item;
        napi_create_string_utf8(env, values[i].c_str(), values[i].size(), &item);
        napi_set_element(env, array, i, item);
    }
    return array;
}

napi_value CreateEmptyArray(napi_env env)
{
    napi_value array;
    napi_create_array_with_length(env, 0, &array);
    return array;
}

napi_value CreateString(napi_env env, const std::string& value)
{
    napi_value result;
    napi_create_string_utf8(env, value.c_str(), value.size(), &result);
    return result;
}

napi_value CreateBoolean(napi_env env, bool value)
{
    napi_value result;
    napi_get_boolean(env, value, &result);
    return result;
}

std::string ReadStringArgument(napi_env env, napi_value value)
{
    size_t length = 0;
    napi_status status = napi_get_value_string_utf8(env, value, nullptr, 0, &length);
    if (status != napi_ok) {
        return "";
    }

    std::string result(length + 1, '\0');
    size_t copied = 0;
    status = napi_get_value_string_utf8(env, value, result.data(), result.size(), &copied);
    if (status != napi_ok) {
        return "";
    }
    result.resize(copied);
    return result;
}

int ReadIntArgument(napi_env env, napi_value value, int fallback)
{
    int32_t result = fallback;
    napi_status status = napi_get_value_int32(env, value, &result);
    if (status != napi_ok) {
        return fallback;
    }
    return std::max(result, 0);
}

std::vector<std::string> ReadStringArrayArgument(napi_env env, napi_value value)
{
    bool isArray = false;
    napi_is_array(env, value, &isArray);
    if (!isArray) {
        return {};
    }

    uint32_t length = 0;
    napi_get_array_length(env, value, &length);
    std::vector<std::string> result;
    result.reserve(length);

    for (uint32_t i = 0; i < length; ++i) {
        napi_value item;
        if (napi_get_element(env, value, i, &item) != napi_ok) {
            continue;
        }
        result.push_back(ReadStringArgument(env, item));
    }
    return result;
}

} // namespace

napi_value ExtractKeywords(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = { nullptr, nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < 1 || args[0] == nullptr) {
        return CreateEmptyArray(env);
    }

    try {
        const std::string text = ReadStringArgument(env, args[0]);
        const int topK = argc >= 2 && args[1] != nullptr ? ReadIntArgument(env, args[1], 5) : 5;
        return CreateStringArray(env, ExtractKeywordsNative(text, topK));
    } catch (...) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, TEXT_ANALYZER_LOG_DOMAIN, TEXT_ANALYZER_LOG_TAG, "ExtractKeywords failed");
        return CreateEmptyArray(env);
    }
}

napi_value ScoreSentences(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = { nullptr, nullptr, nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < 1 || args[0] == nullptr) {
        return CreateEmptyArray(env);
    }

    try {
        const std::string text = ReadStringArgument(env, args[0]);
        const std::vector<std::string> keywords = argc >= 2 && args[1] != nullptr
            ? ReadStringArrayArgument(env, args[1])
            : std::vector<std::string>();
        const int topK = argc >= 3 && args[2] != nullptr ? ReadIntArgument(env, args[2], 2) : 2;
        return CreateStringArray(env, ScoreSentencesNative(text, keywords, topK));
    } catch (...) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, TEXT_ANALYZER_LOG_DOMAIN, TEXT_ANALYZER_LOG_TAG, "ScoreSentences failed");
        return CreateEmptyArray(env);
    }
}

napi_value HashPassword(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = { nullptr, nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < 2 || args[0] == nullptr || args[1] == nullptr) {
        return CreateString(env, "");
    }

    try {
        const std::string password = ReadStringArgument(env, args[0]);
        const std::string salt = ReadStringArgument(env, args[1]);
        return CreateString(env, HashPasswordNative(password, salt));
    } catch (...) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, TEXT_ANALYZER_LOG_DOMAIN, TEXT_ANALYZER_LOG_TAG, "HashPassword failed");
        return CreateString(env, "");
    }
}

napi_value GenerateSalt(napi_env env, napi_callback_info info)
{
    try {
        return CreateString(env, GenerateSaltNative());
    } catch (...) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, TEXT_ANALYZER_LOG_DOMAIN, TEXT_ANALYZER_LOG_TAG, "GenerateSalt failed");
        return CreateString(env, "");
    }
}

napi_value VerifyPassword(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = { nullptr, nullptr, nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < 3 || args[0] == nullptr || args[1] == nullptr || args[2] == nullptr) {
        return CreateBoolean(env, false);
    }

    try {
        const std::string password = ReadStringArgument(env, args[0]);
        const std::string salt = ReadStringArgument(env, args[1]);
        const std::string expectedHash = ReadStringArgument(env, args[2]);
        return CreateBoolean(env, VerifyPasswordNative(password, salt, expectedHash));
    } catch (...) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, TEXT_ANALYZER_LOG_DOMAIN, TEXT_ANALYZER_LOG_TAG, "VerifyPassword failed");
        return CreateBoolean(env, false);
    }
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "extractKeywords", nullptr, ExtractKeywords, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "scoreSentences", nullptr, ScoreSentences, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "hashPassword", nullptr, HashPassword, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "generateSalt", nullptr, GenerateSalt, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "verifyPassword", nullptr, VerifyPassword, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module textAnalyzerModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "text_analyzer",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterTextAnalyzerModule(void)
{
    napi_module_register(&textAnalyzerModule);
}
