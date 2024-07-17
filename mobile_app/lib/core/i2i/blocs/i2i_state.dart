part of 'i2i_bloc.dart';

abstract class I2IState extends Equatable {
  const I2IState();

  @override
  List<Object> get props => [];
}

class OnStartup extends I2IState {
  const OnStartup();
}

class ContentLoaded extends I2IState {
  final File image;
  final int selectedID;

  const ContentLoaded({required this.image, required this.selectedID});
}

class TransferWorking extends I2IState {
  const TransferWorking();
}

class TransferCompleted extends I2IState {
  final String imageCore;
  
  const TransferCompleted({required this.imageCore});
}

class LoadingContents extends I2IState {
  const LoadingContents();
}
