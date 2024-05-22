import axios from '@api/axios';
import { AxiosError, AxiosResponse } from 'axios';

import { BaseResponse } from '@/types/Api';
import { ConfirmAuthCodeData, SignUpData } from '@/types/User';

export async function confirmAuthCode<T>(
  data: ConfirmAuthCodeData,
  onSuccess: (data: T) => void,
  onFail: (err: AxiosError) => void,
): Promise<void> {
  axios
    .post<BaseResponse<T>>('/api/v1/mail/confirm', data)
    .then((res: AxiosResponse<BaseResponse<T>>) => onSuccess(res.data.data))
    .catch((err: AxiosError) => onFail(err));
}

export async function signUp<T>(
  data: SignUpData,
  onSuccess: (data: T) => void,
  onFail: (err: AxiosError) => void,
): Promise<void> {
  axios
    .post<BaseResponse<T>>('/api/v1/member', data)
    .then((res: AxiosResponse<BaseResponse<T>>) => onSuccess(res.data.data))
    .catch((err: AxiosError) => onFail(err));
}
