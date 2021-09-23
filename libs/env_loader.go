package libs

import "os"

var _envLoader EnvLoader = nil

type EnvLoader interface {
	GetValue(key string) string
}

type envLoader struct{}

func (loader *envLoader) GetValue(key string) string {
	return os.Getenv(key)
}

func GetEnvLoader() EnvLoader {
	if _envLoader == nil {
		_envLoader = &envLoader{}
	}
	return _envLoader
}
