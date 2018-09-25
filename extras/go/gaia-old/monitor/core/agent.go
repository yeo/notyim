package core

type Agent interface {
	StopWorker(string) (bool, error)
}
